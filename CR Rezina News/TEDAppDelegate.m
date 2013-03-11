//
//  TEDAppDelegate.m
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDAppDelegate.h"
//#import "TEDMenuViewController.h"
#include <QuartzCore/QuartzCore.h>
#include "KYCircleMenu.h"
#import "CircleMenuViewController.h"

@interface TEDAppDelegate (Private)

- (void)startupAnimationDone: (NSString *) animationID
                    finished: (NSNumber *) finished
                     context: (void *) context;

- (UIWindow *) customizeWindow: (UIWindow *) window
                   withTexture: (NSString *) filename;

@end


@implementation TEDAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize splashView;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
}

- (UIWindow *) customizeWindow: (UIWindow *) window
                   withTexture: (NSString *) filename
{
    [window setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: filename]]];
    return window;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.window = [self customizeWindow: self.window
                            withTexture: @"bg.png"];
    
    [self.window.layer setCornerRadius: 5.0f];
    [self.window.layer setMasksToBounds: YES];
 
    // Override point for customization after application launch.
    
    
    // Navigation Controller
    UINavigationController * navigationController = [UINavigationController alloc];
    
    // Circle Menu
    CircleMenuViewController * circleMenuViewController = [CircleMenuViewController alloc];
    
    // Set the cricle menu vc as the root vc
    [navigationController initWithRootViewController: circleMenuViewController];
    //[navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    // Setup circle menu with basic configuration
    [circleMenuViewController initWithButtonCount: 5
                                         menuSize: 320.f
                                       buttonSize: 85.f
                            buttonImageNameFormat: @"main_menu_btn_%.2d.png"
                                 centerButtonSize: 130.f
                            centerButtonImageName: @"coatofarms.png"
                  centerButtonBackgroundImageName: @"navigationClearButtonBG.png"];

    // Set navigation controller as the root vc
    [self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

    /*
    self.viewController = [[TEDMenuViewController alloc] init];
	 self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    */
     
    // splash animation
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 72.5, 210, 335)];
    splashView.image = [UIImage imageNamed:@"screen_coatofarms.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.6];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 1;
    splashView.frame = CGRectMake(119, 174.5, 80, 130);
    [UIView commitAnimations];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
