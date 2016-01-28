//
// Created by Paltr on 09.12.15.
// Copyright (c) 2015 UFS. All rights reserved.
//

#import "VKTypes.h"

/*!
    Types of photos that can be requested from social network.
 */
typedef enum
{
  PHOTO_50_SQUARE, /*! 50px x 50px photo */
  PHOTO_100_SQUARE, /*! 100px x 100px photo */
  PHOTO_200_SQUARE /*! 200px x 200px photo */
} PhotoId;

/*!
    @class VKInfoProvider
    
    @brief This class asynchronously requests data from VK social network.
 */
@interface VKInfoProvider : NSObject

  /*! Single class' instance. */
  + (VKInfoProvider*)instance;

  /*! User id used in the social network. Is provided after user looged in. */
  @property(nonatomic, readonly) NSString* userId;
  /*! Friends' photo type requested from server. */
  @property(nonatomic) PhotoId defaultPhotoId;
  /*! Error handling block. All errors are sended to it. */
  @property(nonatomic, copy) void (^errorHandler)(NSString*);

  /*!
      @brief Asynchronously fetches array with current user's friends' info. Cache is used.
      @param block Block that accepts the resulting array of VKUserInfo.
      @see VKUserInfo
      @see userId
   */
  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block;
  /*!
      @brief Asynchronously fetches array with current user's friends' info.
      @param block Block that accepts the resulting array of VKUserInfo.
      @param useCache TRUE to use cache(performance issue).
      @see VKUserInfo
      @see userId
   */
  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block useCache:(BOOL)useCache;
  /*!
      @brief Asynchronously fetches array with user's friends' info. Cache is used.
      @param block Block that accepts the resulting array of VKUserInfo.
      @param userId Id for the user which friends are requested.
      @see VKUserInfo
   */
  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block forUserWithId:(NSString*)userId;
  /*!
      @brief Asynchronously fetches array with user's friends' info.
      @param block Block that accepts the resulting array of VKUserInfo.
      @param userId Id for the user which friends are requested.
      @param useCache TRUE to use cache(performance issue).
      @see VKUserInfo
   */
  - (void)fetchFriendInfoArrayToBlock:(void (^)(NSArray*))block
                        forUserWithId:(NSString*)userId
                             useCache:(BOOL)useCache;
  /*!
      @brief Asynchronously fetches array with user's subscribed groups' info.
      @param block Block that accepts the resulting array of VKGroupInfo.
      @param userId Id for the user which subscription groups are requested.
      @see VKGroupInfo
   */
  - (void)fetchSubscribedGroupInfoArrayToBlock:(void (^)(NSArray*))block forUserWithId:(NSString*)userId;

@end