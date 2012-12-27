//
//  NAMenuItemView.m
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//


#import "NAMenuItemView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NAMenuItemView
@synthesize imageView;
@synthesize label;
@synthesize button;

- (id)init {
	self = [super init];
	
	if (self) {
		NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NAMenuItemView" owner:self options:nil];
		[self addSubview:[views objectAtIndex:0]];
		
		// customize the view a bit
		self.imageView.layer.borderWidth = 1.0;
		self.imageView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:0.4].CGColor;
		self.imageView.clipsToBounds = YES;
		self.imageView.layer.cornerRadius = 5.0;
	}
	
	return self;
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[self.button addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - Overriden Setters / Getters

- (void)setTag:(NSInteger)aTag {
	self.button.tag = aTag;
}

- (NSInteger)tag {
	return self.button.tag;
}

@end
