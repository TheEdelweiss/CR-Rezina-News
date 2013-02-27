//
//  TEDViewController.m
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDMenuViewController.h"
#import "UINavigationBar+TEDShadow.h"

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
    
    NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:@"Hartă"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDDistrictMapViewController class]];
    
    NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:@"Contacte"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDContactsViewController class]];
    
    NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:@"Primării"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:@"Felicitări"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:@"Rezina"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[TEDAboutDistrictViewController class]];
    
    NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:@"Organigramă"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item8 = [[NAMenuItem alloc] initWithTitle:@"Conducere"
                                                    image:[UIImage imageNamed:@"icon.png"]
                                                  vcClass:[self class]];
    
    NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:@"Consilieri"
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



- (void)viewDidLoad {
	[super viewDidLoad];

    
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"navBar.png"]
                                                  forBarMetrics: UIBarMetricsDefault];
    
    
	self.navigationItem.title = @"Meniu Principal";
	self.view.backgroundColor = [UIColor clearColor];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage: [UIImage imageNamed:@"navigationClearButtonBG.png"]
                                                      forState: UIControlStateNormal
                                                    barMetrics: UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage: [UIImage imageNamed:@"navigationClearButtonBG.png"]
                                            forState: UIControlStateNormal
                                          barMetrics: UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar dropShadowWithOffset: CGSizeMake(0, 3)
                                                           radius: 2
                                                            color: [UIColor darkGrayColor]
                                                          opacity: 0.5];
    
}


- (void) viewWillAppear:(BOOL)animated{
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
