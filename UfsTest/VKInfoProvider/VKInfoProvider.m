//
// Created by Paltr on 09.12.15.
// Copyright (c) 2015 UFS. All rights reserved.
//

#import "VKInfoProvider+Internal.h"
#import "VKSdk/VKSdk.h"

static VKInfoProvider* _instance;

@interface VKInfoProvider() <VKSdkDelegate>
@end

@implementation VKInfoProvider
{
  void (^_vcPresenter)(UIViewController*);
  NSString* _userId;
  NSMutableArray* _delayedActions;
  NSMutableDictionary* _friendsInfoCache;
}

#pragma mark - Public static methods

  + (VKInfoProvider*)instance
  {
    static VKInfoProvider* infoProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
      infoProvider = [[VKInfoProvider alloc] init];
    });

    return infoProvider;
  }

#pragma mark - Initializer

  - (id)init
  {
    self = [super init];
    [VKSdk initializeWithDelegate:self andAppId:@"5182116"];
    _delayedActions = [NSMutableArray new];
    _friendsInfoCache = [NSMutableDictionary new];
    return self;
  }

#pragma mark - Public methods

  - (void)setVcPresenter:(void (^)(UIViewController*))vcPresenter
  {
    _vcPresenter = vcPresenter;
  }

  - (void (^)(UIViewController*))vcPresenter
  {
    return _vcPresenter;
  }

  - (BOOL)authorized
  {
    return _userId != nil;
  }

  - (NSString*)userId
  {
    return _userId;
  }

  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block
  {
    [self fetchFriendInfoArrayToBlock:block useCache:YES];
  }

  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block useCache:(BOOL)useCache
  {
    [self fetchFriendInfoArrayToBlock:block forUserWithId:nil useCache:useCache];
  }

  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block forUserWithId:(NSString*)userId
  {
    [self fetchFriendInfoArrayToBlock:block forUserWithId:userId useCache:YES];
  }

  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block
                        forUserWithId:(NSString*)userId
                             useCache:(BOOL)useCache
  {
    [self authorizeAndExecuteBlock:^()
    {
      NSString* const actualizedUserId = [self actualizeUserId:userId];
      if(useCache)
      {
        NSArray* const cachedResult = [_friendsInfoCache objectForKey:actualizedUserId];
        if(cachedResult != nil)
        {
          block(cachedResult);
          return; /* done: found in cache */
        }
      }

      VKRequest* const request = [self createFriendsInfoRequestForUserWithId:actualizedUserId
                                                                     photoId:self.defaultPhotoId];
      [self executeVKRequest:request andPassResultToBlock:^(id object)
      {
        NSMutableArray* const result = [NSMutableArray new];
        NSDictionary* const response = object;
        NSDictionary* const users = response[@"items"];
        for(NSDictionary* const userInfoDict in users)
        {
          NSURL* avatarUrl = nil;
          for(NSString* const key in userInfoDict)
          {
            if([key hasPrefix:@"photo_"])
            {
              NSString* const urlStr = userInfoDict[key];
              avatarUrl = [NSURL URLWithString:urlStr];
            }
          }

          NSNumber* const id = userInfoDict[@"id"];
          NSString* const name = userInfoDict[@"first_name"];
          NSString* const surname = userInfoDict[@"last_name"];
          NSDictionary* const cityObject = userInfoDict[@"city"];
          NSString* const cityName = cityObject[@"title"];
          NSArray* const universityObjects = userInfoDict[@"universities"];
          NSDictionary* const firstUniversityObj = universityObjects.firstObject;
          NSString* const universityName = firstUniversityObj[@"name"];
          VKUserInfo* const userInfo = [[VKUserInfo alloc] initWithId:id.stringValue
                                                            avatarUrl:avatarUrl
                                                              surname:surname
                                                                 name:name
                                                                 city:cityName
                                                           university:universityName];

          [result addObject:userInfo];
        }

        [_friendsInfoCache setObject:result forKey:actualizedUserId];
        block(result);
      }];
    }];
  }

  - (void)fetchSubscribedGroupInfoArrayToBlock:(void (^)(NSArray*))block forUserWithId:(NSString*)userId
  {
    [self authorizeAndExecuteBlock:^()
    {
      VKRequest* const request = [self createSubscribedGroupsInfoRequestForUserWithId:userId];
      [self executeVKRequest:request andPassResultToBlock:^(id object)
      {
        NSMutableArray* const result = [NSMutableArray new];
        NSDictionary* const response = object;
        NSArray* const items = response[@"items"];
        for(NSDictionary* const groupDict in items)
        {
          NSString* const name = groupDict[@"name"];
          VKGroupInfo* const groupInfo = [[VKGroupInfo alloc] initWithName:name];
          [result addObject:groupInfo];
        }

        block(result);
      }];
    }];
  }

#pragma mark - Internal methods

  - (BOOL)application:(UIApplication*)application
              openURL:(NSURL*)url
    sourceApplication:(NSString*)sourceApplication
           annotation:(id)annotation
  {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
  }

#pragma mark - VKSdkDelegate protocol implementation

  - (void)vkSdkNeedCaptchaEnter:(VKError*)captchaError
  {
  }

  - (void)vkSdkTokenHasExpired:(VKAccessToken*)expiredToken
  {
  }

  - (void)vkSdkUserDeniedAccess:(VKError*)authorizationError
  {
  }

  - (void)vkSdkShouldPresentViewController:(UIViewController*)controller
  {
    self.vcPresenter(controller);
  }

  - (void)vkSdkReceivedNewToken:(VKAccessToken*)newToken
  {
    [self handleAuthorized];
  }

  - (void)vkSdkAcceptedUserToken:(VKAccessToken*)token
  {
    [self handleAuthorized];
  }

#pragma mark - Private methods

  - (void)authorizeAndExecuteBlock:(void (^)())block
  {
    if(self.authorized)
    {
      block();
    }
    else
    {
      [_delayedActions addObject:block];
      NSArray* const permissions = @[ VK_PER_FRIENDS ];
      if(!VKSdk.wakeUpSession)
      {
        [VKSdk authorize:permissions];
      }
      else
      {
        [self handleAuthorized];
      }
    }
  }

  - (void)handleAuthorized
  {
    VKAccessToken* const accessToken = [VKSdk getAccessToken];
    _userId = accessToken.userId;

    for(id item in _delayedActions)
    {
      void (^block)() = (void (^)())item;
      block();
    }

    [_delayedActions removeAllObjects];
  }

  - (void)executeVKRequest:(VKRequest*)request andPassResultToBlock:(void (^)(NSDictionary*))block
  {
    [request executeWithResultBlock:^(VKResponse* response)
    {
      NSError* error = nil;
      NSData* const responseData = [response.responseString dataUsingEncoding:NSUTF8StringEncoding];
      id const object = [NSJSONSerialization JSONObjectWithData:responseData
                                                        options:0
                                                          error:&error];
      id subresponse = nil;
      if(error == nil)
      {
        if([object isKindOfClass:NSDictionary.class])
        {
          NSDictionary* const result = object;
          subresponse = result[@"response"];
          if(subresponse == nil)
          {
            [self handleErrorWithDescription:@"Resulting json doesn't contain 'response' object"];
          }
        }
        else
        {
          [self handleErrorWithDescription:@"Unexpected json object"];
        }
      }
      else
      {
        [self handleErrorWithDescription:error.description];
      }
      
      block(subresponse);
    }
    errorBlock:^(NSError* error)
    {
      if(error.code != VK_API_ERROR)
      {
        [error.vkError.request repeat];
      }
      else
      {
        [self handleErrorWithDescription:error.description];
      }
      
      block(nil);
    }];
  }

  - (void)handleErrorWithDescription:(NSString*)description
  {
    NSLog(@"VK error: %@", description);
    if(self.errorHandler != nil)
    {
      self.errorHandler(description);
    }
  }

  - (NSString*)getPhotoFieldById:(PhotoId)photoId
  {
    switch(photoId)
    {
      case PHOTO_50_SQUARE: return @"photo_50";
      case PHOTO_100_SQUARE: return @"photo_100";
      case PHOTO_200_SQUARE: return @"photo_200";
    }

    NSAssert(false, @"Unknown photo id");
    return nil;
  }

#pragma mark - Private VK request builders

  - (VKRequest*)createFriendsInfoRequestForUserWithId:(NSString*)userId photoId:(PhotoId)photoId
  {
    NSString* const photoStr = [self getPhotoFieldById:photoId];
    NSString* const fields = [NSString stringWithFormat:@"%@,city,universities", photoStr];
    NSDictionary* const params = @
    {
      VK_API_USER_ID : [self actualizeUserId:userId],
      VK_API_FIELDS : fields
    };
    return [VKApi.friends get:params];
  }

  - (VKRequest*)createSubscribedGroupsInfoRequestForUserWithId:(NSString*)userId
  {
    NSDictionary* const params = @
    {
      VK_API_USER_ID : [self actualizeUserId:userId],
      VK_API_EXTENDED : @"1",
      VK_API_FIELDS : @"name"
    };
    return [VKApi.groups prepareRequestWithMethodName:@"get"
                                        andParameters:params
                                        andHttpMethod:@"GET"
                                      andClassOfModel:VKGroups.class];
  }

  - (NSString*)actualizeUserId:(NSString*)userId
  {
    if(userId == nil)
    {
      return self.userId;
    }
    else
    {
      return userId;
    }
  }

@end