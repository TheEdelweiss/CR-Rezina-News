//
//  TEDArticlesScrollerViewController.h
//  CR Rezina
//
//  Created by Stefan Popa on 06.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEDArticlesViewControllerDataSource.h"
#import "TEDArticlesViewControllerDelegate.h"

@class MGBox;

@interface TEDArticlesScrollerViewController : UIView <UIScrollViewDelegate>
{
    // protocols
    id <TEDArticlesViewControllerDataSource> scrollerDataSource;
    id <TEDArticlesViewControllerDelegate> __unsafe_unretained scrollerDelegate;
}

// =============================================================================
// protocols
@property (nonatomic, unsafe_unretained) id <TEDArticlesViewControllerDelegate> scrollerDelegate;
@property (nonatomic, strong) id <TEDArticlesViewControllerDataSource> scrollerDataSource;

// number of elements
@property  NSInteger numberOfItemsInScroller;


- (MGBox *)parentBoxOf: (UIView *)view;
- (void)start;
- (BOOL) reloadData;
@end
