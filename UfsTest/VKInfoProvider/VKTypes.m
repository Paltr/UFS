//
//  VKTypes.m
//  UfsTest
//
//  Created by Paltr on 09.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import "VKTypes.h"

@implementation VKUserInfo

  @synthesize id = _id;
  @synthesize avatarUrl = _avatarUrl;
  @synthesize surname = _surname;
  @synthesize name = _name;
  @synthesize city = _city;
  @synthesize university = _university;

  - (id)initWithId:(NSString*)id
         avatarUrl:(NSURL*)avatarUrl
           surname:(NSString*)surname
              name:(NSString*)name
              city:(NSString*)city
        university:(NSString*)university
  {
    self = [super init];
    _id = id;
    _avatarUrl = avatarUrl;
    _surname = surname;
    _name = name;
    _city = city;
    _university = university;
    return self;
  }

@end

@implementation VKGroupInfo

  @synthesize name = _name;

  - (id)initWithName:(NSString*)name
  {
    self = [super init];
    _name = name;
    return self;
  }

@end