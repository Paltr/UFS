//
// Created by Paltr on 10.12.15.
// Copyright (c) 2015 UFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTRemoteDataTableVC.h"

@interface UTRemoteDataTableVC(Internal)

  /*!
      @brief Makes asynchronous request for remote data. Must be implemented by inherited object.
  */
  - (void)requestRemoteObjects;
  /*!
      @brief Must be called by inherited object when asynchronous request is done. Fetches the result of the asynchronous call.
      @param objects Array that contains remote objects that represent the result of the asynchronous call.
   */
  - (void)fetchRemoteObjects:(NSArray*)objects;
  /*!
      @brief Creates cell that will display one object from the request's resulting array.
      @return Cell's view.
   */
  - (UITableViewCell*)createCell;
  /*!
      @brief Is called to prepare cell's view for displaying object from the request's resulting array. Must be implemented by inherited class.
      @param cell Cell's view ti prepare.
      @param object Object from the request's resulting array.
   */
  - (void)prepareCell:(UIView*)cell forObject:(id)object;

@end