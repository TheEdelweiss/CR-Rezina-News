//
//  TEDViewController.m
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDMenuViewController.h"


@interface TEDMenuViewController ()
- (NSArray *)createMenuItems;
@end

@implementation TEDMenuViewController


- (id)init {
	self = [super init];
	
	if (self) {
		[self setMenuItems:[self createMenuItems]];
	}
	
	return self;
}


#pragma mark - Local Methods

- (NSArray *)createMenuItems {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	// First Item
	NAMenuItem *item1 = [[NAMenuItem alloc] initWithTitle:@"NEWS"
													 image:[UIImage imageNamed:@"icon.png"]
												   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item8 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];

    
    [items addObject:item1];
    [items addObject:item2];
    [items addObject:item3];
    [items addObject:item4];
    [items addObject:item5];
    [items addObject:item6];
    [items addObject:item7];
    [items addObject:item8];
	[items addObject:item9];
    
	return items;
}


#pragma mark - View Lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad {
	[super viewDidLoad];


	self.navigationItem.title = @"Main Menu";
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillAppear:(BOOL)animated{

  
}



/*- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

@end
