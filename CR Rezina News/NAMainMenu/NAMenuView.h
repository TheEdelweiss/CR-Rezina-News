//
//  NAMenuView.h
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//


#import "NAMenuItem.h"

@class NAMenuView;
@protocol NAMenuViewDelegate <NSObject>
- (NSUInteger)menuViewNumberOfItems:(NAMenuView *)menuView;
- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index;
- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index;
@end

@interface NAMenuView : UIScrollView

@property (nonatomic, assign) id<NAMenuViewDelegate>menuDelegate;

/**
 * You can use these properties if you would like a different number of columns or
 * different-sized menu items.
 */
@property (nonatomic) NSUInteger columnCountPortrait; // default is 3
@property (nonatomic) NSUInteger columnCountLandscape; // default is 4
@property (nonatomic) CGSize itemSize; // default is 100x100.

@end
