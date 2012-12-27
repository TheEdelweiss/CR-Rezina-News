//
//  TEDViewController.m
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDMenuViewController.h"
#import "TEDArticlesViewController.h"

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
	NAMenuItem *item1 = [[NAMenuItem alloc] initWithTitle:@"First Item"
													 image:[UIImage imageNamed:@"icon.png"]
												   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item8 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
	NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item10 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item11 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                     image:[UIImage imageNamed:@"icon.png"]
                                                   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                     image:[UIImage imageNamed:@"icon.png"]
                                                   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item13 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                     image:[UIImage imageNamed:@"icon.png"]
                                                   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item14 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                     image:[UIImage imageNamed:@"icon.png"]
                                                   vcClass:[TEDArticlesViewController class]];
    
    NAMenuItem *item15 = [[NAMenuItem alloc] initWithTitle:@"First Item"
                                                     image:[UIImage imageNamed:@"icon.png"]
                                                   vcClass:[TEDArticlesViewController class]];
    
    [items addObject:item1];
    [items addObject:item2];
    [items addObject:item3];
    [items addObject:item4];
    [items addObject:item5];
    [items addObject:item6];
    [items addObject:item7];
    [items addObject:item8];
    [items addObject:item9];
    [items addObject:item10];
    
    [items addObject:item11];
    [items addObject:item12];
    [items addObject:item13];
    [items addObject:item14];
    [items addObject:item15];
    
   
		
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

    [self.navigationController.navigationBar setHidden:YES];

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
