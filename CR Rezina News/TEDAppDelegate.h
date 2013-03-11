//
//  TEDAppDelegate.h
//  CR Rezina News
//
//  Created by Stefan Popa on 27.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TEDMenuViewController;

@interface TEDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TEDMenuViewController *viewController;
@property (strong, nonatomic) UIImageView *splashView;

@end
