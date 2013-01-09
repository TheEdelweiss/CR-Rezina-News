//
//  TEDArticlesViewController.m
//  CR Rezina
//
//  Created by Stefan Popa on 05.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//
// -----------------------------------------------------------------------------
#import "TEDArticlesScrollerViewController.h"
#import "TEDArticlesViewController.h"
#import "TEDArticleModelObject.h"
#import "TEDHorizontalMenu.h"
#import "TEDLazyImageView.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"
#import "JSONKit.h"
// -----------------------------------------------------------------------------
@interface TEDArticlesViewController ()
@end

@implementation TEDArticlesViewController
// -----------------------------------------------------------------------------
@synthesize articlesScrollerView,
            catMenu,
            baseAPIURL,
            receivedData,
            collectionConnection,
            collection, scrollerIsInit, menuIsInit;
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.baseAPIURL = @"http://ios.md/api_main.php";
        self.collection = [[NSMutableArray alloc] init];
    }
    return self;
}

// -----------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    // ---------------
    
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // ---------------
    
    // frame for articles scroller
    CGRect scrollerFrame =
    CGRectMake(0, 0, screenWidth, screenHeight - 36 -
               self.navigationController.navigationBar.frame.size.height);
    // ---------------
    
    // frame for cat-menu
    CGRect horizontalMenuFrame =
    CGRectMake(0, screenHeight - 36 -
               self.navigationController.navigationBar.frame.size.height, screenWidth, 36);
    // ---------------
    
    // init scroller view
    self.articlesScrollerView =
    [[TEDArticlesScrollerViewController alloc]initWithFrame: scrollerFrame];
    [self.articlesScrollerView setScrollerDataSource: self];
    [self.articlesScrollerView setScrollerDelegate: self];
    [self.view addSubview: self.articlesScrollerView];
    // ---------------
    
    // init cat-menu view
    self.catMenu =
    [[TEDHorizontalMenu alloc]initWithFrame: horizontalMenuFrame];
    [self.view addSubview: self.catMenu];
    [self.catMenu setItemSelectedDelegate:self];
    // ---------------

    
    self.view.backgroundColor =[UIColor colorWithRed: 0.29
                                               green: 0.32
                                                blue: 0.35
                                               alpha: 1];
    
   // start load collection
    [self loadCollectionWithParameters:
     [self composePOSTParamsListWithShortPreview: 20
                              shortPreviewLength: 170
                          shortPreviewCategoryID: NSNotFound
                                 fullArticleAtID: NSNotFound]];
}

// -----------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------------
// POST params string
- (NSString *) composePOSTParamsListWithShortPreview: (NSUInteger)numberOfArticles
                                  shortPreviewLength: (NSUInteger)numberOfChars
                              shortPreviewCategoryID: (NSUInteger)categoryID
                                     fullArticleAtID: (NSUInteger)articleID
{
    NSMutableString *params =
    [[NSMutableString alloc] initWithString: @"getMeArticles="];
    
    if (articleID == NSNotFound) {
        if (numberOfArticles != NSNotFound)
            [params appendFormat: @"&shortPreview=%d", numberOfArticles];
        if (numberOfChars != NSNotFound)
            [params appendFormat: @"&shortPreviewLength=%d", numberOfChars];
        if (categoryID != NSNotFound)
            [params appendFormat: @"&shortPreviewCategory=%d", categoryID];
    }
    else
        [params appendFormat: @"&fullArticleAtID=%d", articleID];
    return params;
}

// -----------------------------------------------------------------------------

- (void) loadCollectionWithParameters: (NSString *)POSTparams
{
    
    [self.collection removeAllObjects];
    
    HUD = [[MBProgressHUD alloc] initWithView: self.navigationController.view];
    HUD.dimBackground = YES;
    [self.navigationController.view addSubview: HUD];
    [HUD show:YES];
    
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL: [NSURL URLWithString: self.baseAPIURL]
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
    
    request.HTTPMethod = @"POST";
    NSString* params = POSTparams;
    request.HTTPBody = [params dataUsingEncoding: NSUTF8StringEncoding];
    

    self.collectionConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                delegate: self];
    if (self.collectionConnection)
        self.receivedData = [NSMutableData data];
}

// -----------------------------------------------------------------------------

- (void) parseJSONResult
{
    NSDictionary *myDict = nil;
    NSString* resultString = [[NSString alloc] initWithData: self.receivedData
                                                   encoding: NSUTF8StringEncoding];
    
    if([resultString isEqualToString:@""]) {
      // empty string, show error
            
        return;
    }
    
    // try to parse string
    @try {
        
        myDict = [resultString objectFromJSONString];

    }
    @catch (NSException * e) {}
    
    
    if (!myDict) {
        
        [self showHUDUsingImage: @"beer.png"
                     andMessage: @"EROARE!"
                 andDetailsText: @"Eroare parsing JSON"
                       andDelay: 1.5];
        return;
    }
    
    
    for (NSDictionary* attributes in myDict) {
        
        TEDArticleModelObject* modelObject =
        [[TEDArticleModelObject alloc] initWithAttributes: attributes];
       
        if ([[modelObject objectForKey: @"thumb"] isEqualToString:@"thumb.jpg"]) {
           
            // If the article has an image
         modelObject.articleImageURL =
          [[NSURL alloc]initWithString:
            [[NSString alloc]
          initWithFormat: @"http://consiliu.rezina.md/content_imgs/articles_imgs/%@/thumb.jpg",
              [modelObject objectForKey: @"id_art"]]];
        }
        
        else modelObject.articleImageURL = NULL;
        
        // article WEB URL 
        modelObject.articleURL =
        [[NSURL alloc] initWithString:
         [[NSString alloc] initWithFormat: @"http://consiliu.rezina.md/view.php?art_id=%@",
          [modelObject objectForKey: @"id_art"]]];
        
        // add to colection NSArray
        [self.collection addObject: modelObject];
   }
    
    if(!self.scrollerIsInit){
        
        [articlesScrollerView start];
        scrollerIsInit = YES;
    }
    else [articlesScrollerView reloadData];
    
    if(!self.menuIsInit){
    
        [self.catMenu startWithURL: [[NSURL alloc]
                                     initWithString:self.baseAPIURL]
                     andPOSTParams: @"getMeCategories="];
    // fade in menu
    self.catMenu.alpha = 0;
    [UIView animateWithDuration: 1.4 animations:^{self.catMenu.alpha = 1;}];
    self.menuIsInit = YES;
   
    }
}

// -----------------------------------------------------------------------------

-(void) showHUDUsingImage: (NSString *) imageName
               andMessage: (NSString *) messageText
           andDetailsText: (NSString *) detailsText
                 andDelay: (NSTimeInterval) delayValue
{
    
   // HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview: HUD];
    
    HUD.customView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed: imageName]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = messageText;
    HUD.detailsLabelText = detailsText;
    HUD.dimBackground = YES;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay: delayValue];
    
}

// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegete
//------------------------------------------------------------------------------
- (void)connection: (NSURLConnection *) connection
didReceiveResponse: (NSURLResponse *) response
{    
    NSInteger connectionStatus = [(NSHTTPURLResponse*) response statusCode];
    
    if(connectionStatus == 200){
        expectedLength = [response expectedContentLength];
        currentLength = 0;
        HUD.mode = MBProgressHUDModeDeterminate;
      
    } else {
        if (connection == collectionConnection)
        {
            HUD.customView =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"checkmark.png"]];
            
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            HUD.labelText = @"EROARE!";
            HUD.detailsLabelText =
            [NSString stringWithFormat:@"Server error code: %i",connectionStatus];
            HUD.dimBackground = YES;
            [HUD hide: YES afterDelay: 1.5];
            
            [self cancelConnection: connection];
        }
    }
}

// -----------------------------------------------------------------------------

- (void) connection: (NSURLConnection *)connection
     didReceiveData: (NSData *)data
{
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
    
    if (connection == self.collectionConnection)
        [receivedData appendData: data];
}

// -----------------------------------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    if (connection == collectionConnection) {
        [self parseJSONResult];
    }
    
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES];
    
    [self cancelConnection: connection];

}

// -----------------------------------------------------------------------------

- (void)connection: (NSURLConnection *) connection
  didFailWithError: (NSError *) error
{
	HUD.customView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"checkmark.png"]];
    
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"EROARE!";
    HUD.detailsLabelText = @"Conectare la server esuata!";
    [HUD hide:YES afterDelay: 1.5];
    
    [self cancelConnection: connection];
}

// -----------------------------------------------------------------------------

- (void) cancelConnection:(NSURLConnection*) connection
{
    if (connection == collectionConnection)
    {
        [collectionConnection cancel];
        self.collectionConnection = nil;
        self.receivedData = nil;
    }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
#pragma mark - MBProgressHUDDelegate
// -----------------------------------------------------------------------------

- (void) hudWasHidden: (MBProgressHUD *)hud {
    
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
   #pragma mark - TEDArticlesScrollerViewController delegate
// -----------------------------------------------------------------------------

- (void) itemSelectedAtIndex: (NSInteger)index
{
    NSLog(@"Item taped at index:%d",index);
    // init web view
}

// -----------------------------------------------------------------------------

- (MGStyledBox *) boxAtIndex: (NSUInteger)index
{
    MGStyledBox *box = [MGStyledBox box];
   
    // fonts styles
    UIFont *headerFont = [UIFont fontWithName: @"Verdana-Bold"
                                         size: 14];
    UIFont *shortContentFont = [UIFont fontWithName: @"TrebuchetMS-Italic"
                                               size: 12];
    UIFont *catAndDateFont = [UIFont fontWithName: @"Verdana"
                                             size: 11];
    // ------
    
    TEDArticleModelObject * object = [collection objectAtIndex: index];
   
    // article image, if exist
    if (object.articleImageURL != NULL) {
    
        TEDLazyImageView *imageView =
        [[TEDLazyImageView alloc] initWithFrame: CGRectMake(0, 0, 296, 116)
                                         andURL: object.articleImageURL];
        
    MGBoxLine *line = [MGBoxLine lineWithLeft: imageView right: nil];
    line.linePadding = 4;
    line.height = 124;
    line.itemPadding = 0;
    [box.topLines addObject:line];
     
    }
    
    // header / title
    NSString *title = [[NSString alloc]initWithFormat: @"%@",
                       [object objectForKey: @"title"]];
    
    MGBoxLine *titleLine = [MGBoxLine multilineWithText: title
                                                   font: headerFont
                                                padding: 14];
   
    titleLine.linePadding = 6;
    titleLine.itemPadding = 0;
    [box.middleLines addObject: titleLine];
    
    // short cotent of article
    NSString *shortContent = [[NSString alloc]initWithFormat: @"%@",
                              [object objectForKey: @"content"]];
    
    MGBoxLine *shortContentLine = [MGBoxLine multilineWithText: shortContent
                                                          font: shortContentFont
                                                       padding: 14];
    shortContentLine.linePadding = 6;
    shortContentLine.itemPadding = 0;
    [box.middleLines addObject: shortContentLine];
 
    // category & date (info line)
    NSString *category = [[NSString alloc]initWithFormat: @"Categorie: %@",
                              [object objectForKey: @"cat_name"]];
   
    NSString *date = [[NSString alloc]initWithFormat: @"Data publicării: %@",
                          [object objectForKey: @"date"]];
    
    MGBoxLine *infoLine = [MGBoxLine lineWithLeft: category right: date];
    infoLine.font = catAndDateFont;
    infoLine.height = 24;
    [box.bottomLines addObject: infoLine];
    
    return box;
}

// -----------------------------------------------------------------------------

- (CGRect) scrollViewDimensions
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    return CGRectMake(0, 0, screenWidth, screenHeight -
                      36 - self.navigationController.navigationBar.frame.size.height);
}

// -----------------------------------------------------------------------------

- (NSUInteger) numberOfBoxesInScroller
{
    return [self.collection count];
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
#pragma mark - TEDHorizontalMenuDelegate delegate
// -----------------------------------------------------------------------------

- (void) menuItemSelectedAtIndex:(NSString*) index
{
    
    [self loadCollectionWithParameters:
     [self composePOSTParamsListWithShortPreview: 20
                              shortPreviewLength: 170
                          shortPreviewCategoryID: [index integerValue]
                                 fullArticleAtID: NSNotFound]];

   // [self.articlesScrollerView reloadData];
}

// -----------------------------------------------------------------------------



@end
