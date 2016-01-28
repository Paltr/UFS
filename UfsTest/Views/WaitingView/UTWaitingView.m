//
//  UTWaitingView.m
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import "UTWaitingView.h"

@implementation UTWaitingView

  + (UTWaitingView*)view
  {
    UTWaitingView* const view = [NSBundle.mainBundle loadNibNamed:@"UTWaitingView" owner:nil options:nil].firstObject;
    return view;
  }

@end