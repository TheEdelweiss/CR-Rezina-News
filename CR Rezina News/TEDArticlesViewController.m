//
//  TEDArticlesViewController.m
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDArticlesViewController.h"
#import "TKAlertCenter.h"

@interface TEDArticlesViewController ()

@end

@implementation TEDArticlesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    
    //[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Hi!"];
	//[[TKAlertCenter defaultCenter] postAlertWithMessage:@"This is the alert system"];
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"We do this ! :)" image:[UIImage imageNamed:@"beer"]];
    
    return self;
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setHidden:NO];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
