//
//  UTUserGroupsTableVC.m
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import "UTUserGroupsTableVC.h"
#import "VKInfoProvider.h"
#import "UTRemoteDataTableVC+Internal.h"

@implementation UTUserGroupsTableVC
{
  NSString* _userId;
}

#pragma mark - Public methods

  - (void)setUserId:(NSString*)userId
  {
    _userId = userId;
  }

#pragma mark - Overridden methods

  - (void)requestRemoteObjects
  {
    const id block = ^(NSArray* groupsArray)
    {
      [self fetchRemoteObjects:groupsArray];
    };
    [VKInfoProvider.instance fetchSubscribedGroupInfoArrayToBlock:block
                                                      forUserWithId:_userId];
  }

  - (UITableViewCell*)createCell
  {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"cell"];
  }

  - (void)prepareCell:(UITableViewCell*)cell forObject:(VKGroupInfo*)groupInfo
  {
    cell.textLabel.text = groupInfo.name;
  }

@end