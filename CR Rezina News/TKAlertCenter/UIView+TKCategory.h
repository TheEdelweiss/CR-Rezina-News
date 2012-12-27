//
//  UIViewAdditions.h
//  Created by Devin Ross on 7/25/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 */


#import <UIKit/UIKit.h>

/** Additional functionality for `UIView`.  */
@interface UIView (TKCategory)


/** Adds a view to the beginning of the receiver’s list of subviews.
 @param view The view to be added. This view is retained by the receiver. After being added, this view appears below of any other subviews.
 */
- (void) addSubviewToBack:(UIView*)view;

/** Rounds of views frame coordinates to the nearest integer. */
- (void) roundOffFrame;


@end