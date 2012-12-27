//
//  NAMenuItem.m
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//


#import "NAMenuItem.h"

@implementation NAMenuItem
@synthesize title;
@synthesize icon;
@synthesize targetViewControllerClass;

#pragma mark - Memory Management

- (id)initWithTitle:(NSString *)aTitle image:(UIImage *)image vcClass:(Class)targetClass {
	self = [super init];
	
	if (self) {
		title = [aTitle copy];
		icon = [image copy];
		targetViewControllerClass = targetClass;
	}
	
	return self;
}



@end
