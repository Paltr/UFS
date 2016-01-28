//
//  UTFriendView.h
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKUserInfo;

@interface UTFriendView : UITableViewCell

  + (UTFriendView*)view;

  @property(nonatomic) VKUserInfo* userInfo;

@end