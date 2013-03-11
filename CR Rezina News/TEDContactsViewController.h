//
//  TEDContactsViewController.h
//  CR Rezina
//
//  Created by Stefan Popa on 16.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEDArticlesViewControllerDataSource.h"
#import "TEDArticlesViewControllerDelegate.h"
#import "NSString+TEDHTMLEntities.h"
#import "TEDMGBoxScrollerView.h"
#import "ToolDrawerView.h"
#import "MBProgressHUD.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"
#import "JSONKit.h"
#import "TEDContactsModel.h"
#include "NSURL+TEDWebAPIURL.h"

@interface TEDContactsViewController : UIViewController <UIScrollViewDelegate,
                                                        TEDArticlesViewControllerDataSource,
                                                        TEDArticlesViewControllerDelegate,
                                                        MBProgressHUDDelegate>

@property (nonatomic, strong) TEDMGBoxScrollerView *scrollerController;
@property (nonatomic, strong)  MBProgressHUD       *HUD;

@property (nonatomic, strong) NSMutableArray  *collection;
@property (nonatomic, strong) NSMutableData   *receivedData;
@property (nonatomic, strong) NSURLConnection *collectionConnection;

// flags
@property BOOL scrollerIsInit;

@end
