//
//  TEDArticlesViewController.h
//  CR Rezina
//
//  Created by Stefan Popa on 05.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEDArticlesViewControllerDataSource.h"
#import "TEDArticlesViewControllerDelegate.h"
#import "TEDHorizontalMenuDelegate.h"
#import "MBProgressHUD.h"

@class TEDArticlesScrollerViewController, TEDHorizontalMenu;

@interface TEDArticlesViewController : UIViewController <UIScrollViewDelegate,
                                                         TEDArticlesViewControllerDataSource,
                                                         TEDArticlesViewControllerDelegate,
                                                         MBProgressHUDDelegate,
                                                         TEDHorizontalMenuDelegate>
{
    
    TEDArticlesScrollerViewController *articlesScrollerView;
    TEDHorizontalMenu *catMenu;
    
    //HUD class instance
    MBProgressHUD *HUD;
    long long expectedLength;
	long long currentLength;
    
    // API URL
    NSString *baseAPIURL;
    
    // NSURL
    NSMutableData *receivedData;
    NSURLConnection *collectionConnection;
    NSMutableArray *collection;

}

@property (nonatomic, strong) TEDArticlesScrollerViewController * articlesScrollerView;
@property (nonatomic, strong) TEDHorizontalMenu *catMenu;

@property (nonatomic, strong) NSString *baseAPIURL;

@property (nonatomic, strong) NSMutableArray *collection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *collectionConnection;

// flags
@property BOOL scrollerIsInit;
@property BOOL menuIsInit;

@end
