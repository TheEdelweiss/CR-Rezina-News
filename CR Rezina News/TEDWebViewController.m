//
//  TEDWebViewController.m
//  CR Rezina
//
//  Created by Stefan Popa on 11.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDWebViewController.h"

@interface TEDWebViewController ()

@end

@implementation TEDWebViewController

@synthesize webView;

// -----------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

// -----------------------------------------------------------------------------

- (id) initWithRequest: (NSURLRequest *)request {
    self = [super init];
    
    if (self) {
        
        // get screen size
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        // ---------------
        
        CGRect webFrame = CGRectMake(0, 0, screenWidth,
                                     screenHeight - 44);

        self.webView = [[UIWebView alloc] initWithFrame: webFrame];
        [self.webView setDelegate: self];
        
        
        [self.webView loadRequest: request];
    }
    return self;
}

// -----------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.webView.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"list.png"]
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(goBack)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
}

// -----------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
   #pragma mark - UIWebView delegate
// -----------------------------------------------------------------------------

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
   
    progressHUD = [[MBProgressHUD alloc] initWithView: self.navigationController.view];
    progressHUD.dimBackground = YES;
    [self.navigationController.view addSubview: progressHUD];
    [progressHUD show:YES];
    progressHUD.labelText =@"Loading ...";

}

// -----------------------------------------------------------------------------

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.view addSubview: self.webView];
    self.webView.alpha = 0;
    [UIView animateWithDuration: 1.0 animations:^{self.webView.alpha = 1;}];
    
    [progressHUD hide:YES afterDelay:0.1];
    [progressHUD removeFromSuperview];
	 progressHUD = nil;
}

// -----------------------------------------------------------------------------

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
     
    progressHUD.labelText =@"Error";
    [progressHUD hide: YES
           afterDelay: 1];
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
// -----------------------------------------------------------------------------

@end