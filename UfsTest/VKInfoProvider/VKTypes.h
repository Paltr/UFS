//
//  VKTypes.h
//  UfsTest
//
//  Created by Paltr on 09.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKUserInfo : NSObject

  - (id)initWithId:(NSString*)id
         avatarUrl:(NSURL*)avatarUrl
           surname:(NSString*)surname
              name:(NSString*)name
              city:(NSString*)city
        university:(NSString*)university;

  @property(nonatomic, readonly) NSString* id;
  @property(nonatomic, readonly) NSURL* avatarUrl;
  @property(nonatomic, readonly) NSString* surname;
  @property(nonatomic, readonly) NSString* name;
  @property(nonatomic, readonly) NSString* city;
  @property(nonatomic, readonly) NSString* university;

@end

@interface VKGroupInfo : NSObject

  - (id)initWithName:(NSString*)name;

  @property(nonatomic, readonly) NSString* name;

@end