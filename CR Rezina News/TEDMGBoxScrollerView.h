//
//  TEDMGBoxScrollerView.h
//  CR Rezina
//
//  Created by Stefan Popa on 17.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEDArticlesViewControllerDataSource.h"
#import "TEDArticlesViewControllerDelegate.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"


@interface TEDMGBoxScrollerView : UIView <UIScrollViewDelegate>
{
    id <TEDArticlesViewControllerDataSource> scrollerDataSource;
    id <TEDArticlesViewControllerDelegate> __unsafe_unretained scrollerDelegate;
}

@property (nonatomic, unsafe_unretained) id <TEDArticlesViewControllerDelegate> scrollerDelegate;
@property (nonatomic, strong) id <TEDArticlesViewControllerDataSource> scrollerDataSource;

// number of elements
@property  NSInteger numberOfItemsInScroller;

- (MGBox *)parentBoxOf: (UIView *)view;
- (void) buildAndStart;
- (BOOL) reloadData;

@end
