//
//  UTUserGroupsTableVC.h
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTRemoteDataTableVC.h"

/*!
    @class UTUserGroupsTableVC
 
    @brief View controller containing the list of groups the user has been subscribed.
 */
@interface UTUserGroupsTableVC : UTRemoteDataTableVC

  - (void)setUserId:(NSString*)userId;

@end