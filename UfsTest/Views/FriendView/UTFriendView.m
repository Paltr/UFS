//
//  UTFriendView.m
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import "UTFriendView.h"
#import "VKInfoProvider.h"
#import "UIImageView+AFNetworking.h"
#import "UTPreviewable.h"

@interface UTFriendView() <UTPreviewable>

  @property(nonatomic) IBOutlet UILabel* nameSurnameLabel;
  @property(nonatomic) IBOutlet UILabel* cityLabel;
  @property(nonatomic) IBOutlet UILabel* universityLabel;
  @property(nonatomic) IBOutlet UIImageView* avatarView;

@end

@implementation UTFriendView
{
  BOOL _previewMode;
  NSURL* _avatarUrl;
}

  + (UTFriendView*)view
  {
    UTFriendView* const view = [NSBundle.mainBundle loadNibNamed:@"UTFriendView" owner:nil options:nil].firstObject;
    return view;
  }

  - (void)setUserInfo:(VKUserInfo*)userInfo
  {
    self.nameSurnameLabel.text = [NSString stringWithFormat:@"%@ %@", userInfo.surname, userInfo.name];
    self.cityLabel.text = userInfo.city;
    self.universityLabel.text = userInfo.university;
    _avatarUrl = userInfo.avatarUrl;
    [self updateAvatar];
  }

#pragma mark - UTPreviewable protocol implementation

  - (void)setPreviewMode:(BOOL)previewMode
  {
    _previewMode = previewMode;
    [self updateAvatar];
  }

#pragma mark - Private methods

  - (void)updateAvatar
  {
    if(!_previewMode && _avatarUrl != nil)
    {
      [self.avatarView setImageWithURL:_avatarUrl];
    }
    else
    {
      [self.avatarView setImageWithURL:nil];
    }
  }

@end