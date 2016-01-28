//
//  AppDelegate.m
//  UfsTest
//
//  Created by Paltr on 09.12.15.
//  Copyright (c) 2015 Paltr. All rights reserved.
//

#import "AppDelegate.h"
#import "VKInfoProvider/VKInfoProvider+Internal.h"

@interface AppDelegate()
@end

@implementation AppDelegate

  - (BOOL)          application:(UIApplication*)application
  didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
  {
    VKInfoProvider.instance.vcPresenter = ^(UIViewController* viewController)
    {
      [self.window.rootViewController presentViewController:viewController
                                                   animated:FALSE
                                                 completion:nil];
    };
    VKInfoProvider.instance.defaultPhotoId = PHOTO_200_SQUARE;
    return YES;
  }

  - (BOOL)application:(UIApplication*)application
              openURL:(NSURL*)url
    sourceApplication:(NSString*)sourceApplication
           annotation:(id)annotation
  {
    return [VKInfoProvider.instance application:application
                                        openURL:url
                              sourceApplication:sourceApplication
                                     annotation:annotation];
  }

@end