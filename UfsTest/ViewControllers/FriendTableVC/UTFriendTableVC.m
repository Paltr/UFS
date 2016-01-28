//
//  UTFriendTableVC.m
//  UfsTest
//
//  Created by Paltr on 09.12.15.
//  Copyright (c) 2015 Paltr. All rights reserved.
//

#import "UTFriendTableVC.h"
#import "UTUserGroupsTableVC.h"
#import "UTRemoteDataTableVC+Internal.h"
#import "UTFriendView.h"
#import "VKInfoProvider.h"

@interface UTFriendTableVC() <UISearchBarDelegate, UISearchDisplayDelegate>
@end

@implementation UTFriendTableVC
{
  NSArray* _objects;
  NSString* _objectsFilter;
}

#pragma mark - Overridden methods

  - (void)requestRemoteObjects
  {
    [VKInfoProvider.instance fetchFriendInfoArrayToBlock:^(NSArray* array)
    {
      _objects = [self sortFriends:array];
      [self fetchRemoteObjects:self.filteredObjects];
    }];
  }

  - (UITableViewCell*)createCell
  {
    return [UTFriendView view];
  }

  - (void)prepareCell:(UTFriendView*)cell forObject:(VKUserInfo*)userInfo
  {
    cell.userInfo = userInfo;
  }

  - (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
  {
    [self performSegueWithIdentifier:@"Segue" sender:_objects[indexPath.row]];
  }

  - (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(VKUserInfo*)sender
  {
    UTUserGroupsTableVC* const viewController = segue.destinationViewController;
    viewController.userId = sender.id;
  }

#pragma mark - UISearchBarDelegate protocol implementation

  - (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
  {
    _objectsFilter = searchText;
  }

  - (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
  {
    _objectsFilter = nil;
    [self fetchRemoteObjects:self.filteredObjects];
  }

#pragma mark - UISearchDisplayDelegate protocol implementation

  - (BOOL)searchDisplayController:(UISearchDisplayController*)controller
 shouldReloadTableForSearchString:(NSString*)searchString
  {
    [self fetchRemoteObjects:self.filteredObjects];
    return YES;
  }

#pragma mark - Event handlers

  - (IBAction)refresh:(UIRefreshControl*)sender
  {
    [VKInfoProvider.instance fetchFriendInfoArrayToBlock:^(NSArray* array)
    {
      _objects = [self sortFriends:array];
      [self fetchRemoteObjects:self.filteredObjects];
      [sender endRefreshing];
    }];
  }

#pragma mark - Private methods

  - (NSArray*)sortFriends:(NSArray*)friends
  {
    NSSortDescriptor* const sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* const sortedFriends = [friends sortedArrayUsingDescriptors:@[ sort ]];
    return sortedFriends;
  }

  - (NSArray*)filteredObjects
  {
    if(_objects == nil || _objectsFilter == nil)
    {
      return _objects;
    }
    else
    {
      NSMutableArray* filteredArray = [NSMutableArray new];
      for(VKUserInfo* const userInfo in _objects)
      {
        if([self field:userInfo.name containsString:_objectsFilter]
          || [self field:userInfo.surname containsString:_objectsFilter]
          || [self field:userInfo.city containsString:_objectsFilter]
          || [self field:userInfo.university containsString:_objectsFilter])
        {
          [filteredArray addObject:userInfo];
        }
      }

      return filteredArray;
    }
  }

  - (BOOL)field:(NSString*)field containsString:(NSString*)string
  {
    if(field == nil)
    {
      return NO;
    }
    else if(string.length == 0)
    {
      return YES;
    }
    else
    {
      return [field rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound;
    }
  }

@end
