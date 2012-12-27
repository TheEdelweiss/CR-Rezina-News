//
//  UIViewAdditions.m
//  Created by Devin Ross on 7/25/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 */

#import "UIView+TKCategory.h"


@implementation UIView (TKCategory)


- (void) addSubviewToBack:(UIView*)view{
	[self insertSubview:view atIndex:0];
}


- (void) roundOffFrame{
	self.frame = CGRectMake((NSInteger)self.frame.origin.x, (NSInteger)self.frame.origin.y, (NSInteger)self.frame.size.width, (NSInteger)self.frame.size.height);
}








@end
