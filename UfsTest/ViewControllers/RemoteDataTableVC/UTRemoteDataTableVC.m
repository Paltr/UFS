//
//  UTRemoteDataTableVC.m
//  UfsTest
//
//  Created by Paltr on 10.12.15.
//  Copyright (c) 2015 UFS. All rights reserved.
//

#import "UTRemoteDataTableVC+Internal.h"
#import "UTWaitingView.h"
#import "UTPreviewable.h"

@interface UTRemoteDataTableVC() <UITableViewDataSource, UITableViewDelegate>
@end

@implementation UTRemoteDataTableVC
{
  UTWaitingView* _waitingView;
  BOOL _requestDone;
  NSArray* _objects;
  NSString* _cellReuseIdentifier;
  CGFloat _cellHeight;
  
  CGPoint _lastScrollOffset;
  NSTimeInterval _lastOffsetCaptureTime;
  BOOL _isScrollingFast;
}

#pragma mark - Internal methods

  - (void)fetchRemoteObjects:(NSArray*)objects
  {
    _requestDone = NO;
    _objects = objects;
    _waitingView = nil;
    [self.tableView reloadData];
  }

#pragma mark - Methods to implement

  - (void)requestRemoteObjects
  {
    NSAssert(false, @"requestRemoteObjects not implemented");
  }

  - (UITableViewCell*)createCell
  {
    NSAssert(false, @"createCell not implemented");
    return nil;
  }

  - (void)prepareCell:(UIView*)cell forObject:(id)object
  {
    NSAssert(false, @"prepareCell:forObject: not implemented");
  }

#pragma mark - UITableViewDataSource protocol implementation

  - (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
  {
    if(self.waitingData)
    {
      if(_requestDone == NO)
      {
        [self requestRemoteObjects];
        _requestDone = YES;
      }

      return 1;
    }
    else
    {
      return _objects.count;
    }
  }

  - (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
  {
    if(self.waitingData)
    {
      return self.waitingView;
    }
    else
    {
      UITableViewCell* cell = nil;
      if(_cellReuseIdentifier != nil)
      {
        cell = [self.tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier];
      }

      if(cell == nil)
      {
        cell = [self createCell];
      }

      [self setCell:cell previewable:_isScrollingFast];
      if(_cellReuseIdentifier == nil)
      {
        _cellReuseIdentifier = cell.reuseIdentifier;
        _cellHeight = cell.frame.size.height;
      }

      const id object = _objects[indexPath.row];
      [self prepareCell:cell forObject:object];
      return cell;
    }
  }

#pragma mark - UITableViewDelegate protocol implementation

  - (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
  {
    if(self.waitingData)
    {
      return self.waitingView.frame.size.height;
    }
    else
    {
      return self.cellHeight;
    }
  }

  - (void)scrollViewDidScroll:(UIScrollView*)scrollView
  {
    const CGPoint currentOffset = scrollView.contentOffset;
    const NSTimeInterval currentTime = NSDate.timeIntervalSinceReferenceDate;
    const NSTimeInterval timeDiff = currentTime - _lastOffsetCaptureTime;
    const CGFloat distance = currentOffset.y - _lastScrollOffset.y;
    const CGFloat scrollSpeedNotAbs = (distance / timeDiff) / 1000; /* in points per millisecond */
    const CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
    if(scrollSpeed > 0.5)
    {
      [self handleFastScrolling];
    }
    else
    {
      [self handleSlowScrolling];
    }

    _lastScrollOffset = currentOffset;
    _lastOffsetCaptureTime = currentTime;
  }

  - (void)scrollViewWillEndDragging:(UIScrollView*)scrollView
                       withVelocity:(CGPoint)velocity
                targetContentOffset:(inout CGPoint*)targetContentOffset
  {
    if(velocity.y == 0.0)
    {
      [self handleSlowScrolling];
    }
  }

#pragma mark - Private methods

  - (BOOL)waitingData
  {
    return _objects == nil;
  }

  - (UTWaitingView*)waitingView
  {
    if(_waitingView == nil)
    {
      _waitingView = [UTWaitingView view];
    }

    return _waitingView;
  }

  - (CGFloat)cellHeight
  {
    if(_cellHeight == 0.0)
    {
      UITableViewCell* const cell = [self createCell];
      _cellHeight = cell.frame.size.height;
    }

    return _cellHeight;
  }

  - (void)handleFastScrolling
  {
    if(!_isScrollingFast)
    {
      _isScrollingFast = YES;
    }
  }

  - (void)handleSlowScrolling
  {
    if(_isScrollingFast)
    {
      for(UITableViewCell* const cell in self.tableView.visibleCells)
      {
        [self setCell:cell previewable:NO];
      }

      _isScrollingFast = NO;
    }
  }

  - (void)setCell:(UITableViewCell*)cell previewable:(BOOL)previewable
  {
    if([cell conformsToProtocol:@protocol(UTPreviewable)])
    {
      const id<UTPreviewable> previewableView = (id<UTPreviewable>)cell;
      [previewableView setPreviewMode:previewable];
    }
  }

@end