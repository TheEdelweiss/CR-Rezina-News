//
//  NAMenuView.m
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//


#import "NAMenuView.h"
#import "NAMenuItemView.h"

@interface NAMenuView()
@property (nonatomic, retain) NSMutableArray *itemViews;
- (void)setupItemViews;
- (void)itemPressed:(id)sender;
@end

@implementation NAMenuView
@synthesize menuDelegate;
@synthesize itemViews;
@synthesize columnCountPortrait, columnCountLandscape, itemSize;

#pragma mark - Memory Management

- (id)init {
	self = [super init];
	
	if (self) {
		itemViews = [[NSMutableArray alloc] init];
		
		// set some defaults
		columnCountPortrait = 3;
		columnCountLandscape = 4;
		itemSize = CGSizeMake(100, 100);
	}
	
	return self;
}


#pragma mark - View Lifecycle

- (void)layoutSubviews {
	[super layoutSubviews];
	
	NSUInteger numColumns = self.bounds.size.width > self.bounds.size.height ? self.columnCountLandscape : self.columnCountPortrait;
	
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
	if (self.itemViews.count != numItems) {
		[self setupItemViews];
	}
	
	CGFloat padding = roundf((self.bounds.size.width - (self.itemSize.width * numColumns)) / (numColumns + 1));
	NSUInteger numRows = numItems % numColumns == 0 ? (numItems / numColumns) : (numItems / numColumns) + 1;
	CGFloat totalHeight = ((self.itemSize.height + padding) * numRows) + padding;
	
	// get an even y padding if less than the max number of rows
	CGFloat yPadding = padding;
	if (totalHeight < self.bounds.size.height) {
		CGFloat leftoverHeight = self.bounds.size.height - totalHeight;
		CGFloat extraYPadding = roundf(leftoverHeight / (numRows + 1));
		yPadding += extraYPadding;
		
		totalHeight = ((self.itemSize.height + yPadding) * numRows) + yPadding;
	}
	
	// get an even x padding if we have less than a single row of items
	if (numRows == 1 && numItems < numColumns) {
		padding = roundf((self.bounds.size.width - (numItems * self.itemSize.width)) / (numItems + 1));
	}
	
	for (int i = 0; i < numItems; i++) {
		UIView *item = [self.itemViews objectAtIndex:i];
		NSUInteger column = i % numColumns;
		NSUInteger row = i / numColumns;
		
		CGFloat xOffset = (column * (self.itemSize.width + padding)) + padding;
		CGFloat yOffset = (row * (self.itemSize.height + yPadding)) + yPadding;
		item.frame = CGRectMake(xOffset, yOffset, self.itemSize.width, self.itemSize.height);
	}
	
	
	
	self.contentSize = CGSizeMake(self.bounds.size.width, totalHeight);
}


#pragma mark - Local Methods

- (void)setupItemViews {
	for (UIView *view in self.itemViews) {
		[view removeFromSuperview];
	}
	
	[self.itemViews removeAllObjects];
	
	// now add the new objects
	NSUInteger numItems = [self.menuDelegate menuViewNumberOfItems:self];
	
	for (NSUInteger i = 0; i < numItems; i++) {
		NAMenuItemView *itemView = [[NAMenuItemView alloc] init];
		NAMenuItem *menuItem = [self.menuDelegate menuView:self itemForIndex:i];
								
		itemView.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
		itemView.label.text = menuItem.title;
		itemView.imageView.image = menuItem.icon;
		itemView.tag = i;
		[itemView addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.itemViews addObject:itemView];
		[self addSubview:itemView];
	}
}

- (void)itemPressed:(UIButton *)sender {
	NSParameterAssert(sender);
	[self.menuDelegate menuView:self didSelectItemAtIndex:sender.tag];
}

@end
