//
// Created by Paltr on 14.12.15.
// Copyright (c) 2015 UFS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @protocol UTPreviewable
 
    @brief Used by UTRemoteDataTableVC to check if cell's view can be previewed to provide best performance when scrolling table.
    @see UTRemoteDataTableVC
 */
@protocol UTPreviewable<NSObject>

  /*!
      @brief Switches off/on the preview mode of the view. In preview mode the content of the view must be as simple as possible.
      @param previewMode TRUE to enable preview mode, FALSE otherwise.
   */
  - (void)setPreviewMode:(BOOL)previewMode;

@end