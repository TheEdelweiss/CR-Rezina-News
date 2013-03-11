//
//  CircleMenuViewController.m
//  KYCircleMenuDemo
//
//  Created by Kjuly on 7/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CircleMenuViewController.h"
#import "TEDArticlesViewController.h"
#import "TEDDistrictMapViewController.h"
#import "TEDContactsViewController.h"
#import "TEDAboutDistrictViewController.h"
#import "TEDAboutViewController.h"
#import "UINavigationBar+TEDShadow.h"
#include <QuartzCore/QuartzCore.h>

@implementation CircleMenuViewController

- (void)dealloc {

}

- (id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Modify buttons' style in circle menu
  for (UIButton * button in [self.menu subviews])
       [button setAlpha: 1];
    
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"navBar.png"]
                                                  forBarMetrics: UIBarMetricsDefault];
    
    
	self.navigationItem.title = @"Meniu";
	self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"menu_bg.png"]]];
    
    
    
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
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans-Bold" size:16.0], UITextAttributeFont,
      CGSizeMake(0, 1),UITextAttributeTextShadowOffset,
      [UIColor colorWithWhite: 0.0 alpha: 0.9], UITextAttributeTextShadowColor,nil]];
   
    
    [self performSelector: @selector(open)
               withObject: nil
               afterDelay: 0.5];
    
    /*
     */
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - KYCircleMenu Button Action

// Run button action depend on their tags:
//
// TAG:        1       1   2      1   2     1   2     1 2 3     1 2 3
//            \|/       \|/        \|/       \|/       \|/       \|/
// COUNT: 1) --|--  2) --|--   3) --|--  4) --|--  5) --|--  6) --|--
//            /|\       /|\        /|\       /|\       /|\       /|\
// TAG:                             3       3   4     4   5     4 5 6
//
- (void)runButtonActions:(id)sender {
  [super runButtonActions:sender];
  
    UIViewController * viewController;
    
    switch ([sender tag])
    
    {   //TEDArticlesViewController
        case 1:
               viewController = [[TEDDistrictMapViewController alloc] init];
               [viewController setTitle:@"Harta Raionului"];
               break;
            
        case 2:
               viewController = [[TEDArticlesViewController alloc] init];
               //[viewController setTitle:@"Noutăți"];
               break;
 
        case 3:
               viewController = [[TEDContactsViewController alloc] init];
               [viewController setTitle:@"Contacte"];
               break;
       
        case 4:
               viewController = [[TEDAboutDistrictViewController alloc] init];
               [viewController setTitle:@"Despre Raion"];
               break;
        
        case 5:
               viewController = [[TEDAboutViewController alloc] init];
               [viewController setTitle:@"Despre autor"];
               break;
        
        default:
               viewController = [[UIViewController alloc] init];
               [viewController setTitle:@"Empty VC"];
               break;     
    }
  
  // Use KYCircleMenu's |-pushViewController:| to push vc
  [self pushViewController: viewController];

}

@end
