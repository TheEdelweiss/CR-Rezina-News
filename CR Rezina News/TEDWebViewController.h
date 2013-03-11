//
//  TEDWebViewController.h
//  CR Rezina
//
//  Created by Stefan Popa on 11.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TEDWebViewController : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    MBProgressHUD *progressHUD;
}

@property (nonatomic, strong) UIWebView *webView;

- (id) initWithRequest: (NSURLRequest *)request;

@end
