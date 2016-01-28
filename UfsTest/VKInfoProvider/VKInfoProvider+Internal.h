//
// Created by Paltr on 09.12.15.
// Copyright (c) 2015 UFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKInfoProvider.h"

@interface VKInfoProvider(Internal)

  @property(nonatomic, copy) void (^vcPresenter)(UIViewController*);

  - (BOOL)application:(UIApplication*)application
              openURL:(NSURL*)url
    sourceApplication:(NSString*)sourceApplication
           annotation:(id)annotation;

@end