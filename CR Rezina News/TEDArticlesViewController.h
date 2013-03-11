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
#import "TEDArticlesScrollerViewController.h"
#import "TEDHorizontalMenuDelegate.h"
#import "MBProgressHUD.h"
#import "TEDArticleModelObject.h"
#import "TEDHorizontalMenu.h"
#import "TEDLazyImageView.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"
#import "JSONKit.h"
#import "NSString+TEDHTMLEntities.h"
#import "TEDWebViewController.h"
#import "NSURL+TEDWebAPIURL.h"
#import "ToolDrawerView.h"
#import "UISearchBar+TEDSearchBar.h"
#import "TEDPaginatorModel.h"

@class TEDArticlesScrollerViewController, TEDHorizontalMenu;

@interface TEDArticlesViewController : UIViewController <UIScrollViewDelegate,
                                                         TEDArticlesViewControllerDataSource,
                                                         TEDArticlesViewControllerDelegate,
                                                         MBProgressHUDDelegate,
                                                         TEDHorizontalMenuDelegate,
                                                         UISearchBarDelegate>
{
    
    TEDArticlesScrollerViewController *articlesScrollerView;
    TEDHorizontalMenu *catMenu;
    ToolDrawerView *toolDrawerView;
    UISearchBar *searchField;
    
    //HUD class instance
    MBProgressHUD *HUD;

    
    NSMutableString *currentCategory;
    
    // NSURL
    NSMutableData *receivedData;
    NSURLConnection *collectionConnection;
    NSMutableArray *collection;

}

@property (nonatomic, strong) MBProgressHUD *HUD;


@property (nonatomic, strong) TEDArticlesScrollerViewController * articlesScrollerView;
@property (nonatomic, strong) TEDHorizontalMenu *catMenu;
@property (nonatomic, strong) ToolDrawerView *toolDrawerView;
@property (nonatomic, strong) UISearchBar *searchField;

@property (nonatomic, strong) NSMutableString *currentCategory;
@property (nonatomic, strong) NSMutableString *currentCategoryName;
@property NSUInteger currentPageNumber;
@property (nonatomic, strong) TEDPaginatorModel *paginator;

@property (nonatomic, strong) NSMutableArray *collection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *collectionConnection;


// flags
@property BOOL scrollerIsInit;
@property BOOL menuIsInit;
@property BOOL searchResultsIsShow;

@end
