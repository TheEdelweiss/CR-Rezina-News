//
//  TEDArticlesViewController.m
//  CR Rezina
//
//  Created by Stefan Popa on 05.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
#import "TEDArticlesViewController.h"
#import <QuartzCore/QuartzCore.h>
// -----------------------------------------------------------------------------
@interface TEDArticlesViewController ()
@end

@implementation TEDArticlesViewController
// -----------------------------------------------------------------------------
@synthesize articlesScrollerView,
            catMenu,
            receivedData,
            collectionConnection,
            collection, scrollerIsInit,
            menuIsInit, currentCategory,
            searchField, toolDrawerView,
            HUD, paginator, currentPageNumber,
            searchResultsIsShow;
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.collection = [[NSMutableArray alloc] init];
        
        // refresh button
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"refresh.png"]
                                                                          style: UIBarButtonItemStylePlain
                                                                         target: self
                                                                         action: @selector (refreshScroller)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject: refreshButton];
        
        // go home button
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"home.png"]
                                                                       style: UIBarButtonItemStylePlain
                                                                      target: self
                                                                      action: @selector(goBack)];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
        self.currentCategory = [[NSMutableString alloc] initWithString: @"all"];
        
        self.paginator = [[TEDPaginatorModel alloc] initModel];
        
    }
    
    return self;
}

// -----------------------------------------------------------------------------
- (void) goBack
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(void) refreshScroller
{
    // refresh with last category selected
    [self hideKeyboard];
    [self menuItemSelectedAtIndex: self.currentCategory];
    
    self.searchResultsIsShow = NO;
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // -------------------------------------------------------------------------
    
    UISwipeGestureRecognizer *rightSwipe =
       [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                 action: @selector(goBackToPreviousPage)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer: rightSwipe];
    // -------------------------------------------------------------------------
    
    UISwipeGestureRecognizer *leftSwipe =
    [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                              action: @selector(goForvardToNextPage)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer: leftSwipe];
    // -------------------------------------------------------------------------
    
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
    
    // frame for categories menu
    CGRect horizontalMenuFrame =
    CGRectMake(0, screenHeight - 41 -
               self.navigationController.navigationBar.frame.size.height, screenWidth, 41);
    CGRect horizontalMenuScrollerFrame = CGRectMake(8, 14, screenWidth-16, 36);
    // ---------------
    
    // init cat-menu view
    self.catMenu =
    [[TEDHorizontalMenu alloc]initWithFrame: horizontalMenuScrollerFrame];
    
    UIView *catMenuBG = [[UIView alloc] initWithFrame: horizontalMenuFrame];
    catMenuBG.backgroundColor = [[UIColor alloc] initWithPatternImage:
                                 [UIImage imageNamed:@"category_scroller_bg.png"]];
    [catMenuBG addSubview: self.catMenu];
    
    
    
    [self.catMenu setItemSelectedDelegate:self];
    // ---------------
    
    // init scroller view
    self.articlesScrollerView =
    [[TEDArticlesScrollerViewController alloc]initWithFrame: scrollerFrame];
    [self.articlesScrollerView setScrollerDataSource: self];
    [self.articlesScrollerView setScrollerDelegate: self];
    
    // put to articles view
    [self.view addSubview: self.articlesScrollerView];
    [self.view addSubview: catMenuBG];
    // ---------------
    
    self.view.backgroundColor =[UIColor clearColor];
    
    self.toolDrawerView = [[ToolDrawerView alloc]initInVerticalCorner: kTopCorner
                                                  andHorizontalCorner: kRightCorner
                                                               moving: kHorizontally];
    [self.view addSubview: self.toolDrawerView];
    
    self.searchField= [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 280, 25)
                                                 andPlaceholder: @"Căutați ceva?"];
    
    UIImage *resizableSearchBarBG = [[UIImage imageNamed:@"categoryButoonBG.png" ]
                                     resizableImageWithCapInsets: UIEdgeInsetsMake(10, 5, 10, 5)];
    self.searchField.backgroundImage = resizableSearchBarBG;
    
    self.searchField.delegate = self;
    [self.toolDrawerView  appendSearchBar: self.searchField];
   
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(hideKeyboard)
                                                 name: @"SearchOff"
                                               object: nil];
    
    // start load collection
    [self loadCollectionAtURL: [[NSURL alloc] initWithCategoryID: NSNotFound
                                                   andPageNumber: NSNotFound]];
    self.currentPageNumber = 1;
}

- (void) hideKeyboard
{
    [self.searchField resignFirstResponder];
}

// -----------------------------------------------------------------------------
   #pragma mark UISearchBarDelegate delegate methods
// -----------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSString *searchKeywords = [searchBar.text stringByReplacingOccurrencesOfString: @"."
                                                                         withString: @""];
    
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString: @"/"
                                                               withString: @""];
    
    if ([searchKeywords length] < 4) {
        // show allert - no more pages
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: self.navigationController.view
                                                  animated: YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"";
        hud.detailsLabelText = [NSString stringWithFormat:@"Cuvîntul-cheie : ' %@ ', este prea mic, încercați altul (din 4, și mai multe  caractere).", searchKeywords];
        hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                                size: 14];
        hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];

    } else
         {
            [self.toolDrawerView close];
             self.searchResultsIsShow = YES;
             
             [self loadCollectionAtURL: [[NSURL alloc]initWithSearchKeywords: searchKeywords]];

         }
}
// -----------------------------------------------------------------------------



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

- (void) loadCollectionAtURL: (NSURL *) URL
{
    
    [self.collection removeAllObjects];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.HUD.dimBackground = YES;
    
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL: URL
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
    
    request.HTTPMethod = @"GET";
   
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
    if([resultString isEqualToString:@""])
    {
        return;
    }
    
    // try to parse string
    @try {
           myDict = [resultString objectFromJSONString];
         }
          @catch (NSException * e) {}
    
    if (!myDict)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"EROARE!";
        hud.detailsLabelText =@"Eroare parsing JSON";
        hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                                size: 14];
        hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
        
        [self performSelector: @selector(goBack)
                   withObject: nil
                   afterDelay: 2];
        
        return;
    }
    
    for (NSDictionary* attributes in myDict)
    {
        TEDArticleModelObject* modelObject =
        [[TEDArticleModelObject alloc] initWithAttributes: attributes];
       
        if ([[modelObject objectForKey: @"thumb"] isEqualToString:@"thumb.jpg"]) {
           
        // If the article has an image
            modelObject.articleImageURL = [[NSURL alloc] initWithImageAtArticleID:
                                           (NSUInteger)[[modelObject objectForKey: @"id_art"] integerValue]];
     }
        
        else modelObject.articleImageURL = NULL;
        
        // article WEB URL 
        modelObject.articleURL = [[NSURL alloc] initWithEffectiveURLOfArticleAtIndex:
                                            (NSUInteger)[[modelObject objectForKey: @"id_art"] integerValue]];
            
        // add to colection NSArray
        [self.collection addObject: modelObject];
   }
    
    if(!self.scrollerIsInit)
    {
        [articlesScrollerView start];
        scrollerIsInit = YES;
    }
    else [articlesScrollerView reloadData];
    
    if(!self.menuIsInit)
    {
        [self.catMenu startWithURL: [[NSURL alloc] initWithAllCategories: NSNotFound]];
        
    }
}

// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegete
//------------------------------------------------------------------------------
- (void)connection: (NSURLConnection *) connection
didReceiveResponse: (NSURLResponse *) response
{    
    NSInteger connectionStatus = [(NSHTTPURLResponse*) response statusCode];
       
    if(connectionStatus == 200)
    {
              
    } else {
            if (connection == collectionConnection)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                                          animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"EROARE!";
                hud.detailsLabelText =
                [NSString stringWithFormat:@"Server error code: %i",connectionStatus];
                hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                                        size: 14];
                hud.dimBackground = YES;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                
                [self cancelConnection: connection];
                
                [self performSelector: @selector(goBack)
                           withObject: nil
                           afterDelay: 2];
                
            }
        }
}

// -----------------------------------------------------------------------------

- (void) connection: (NSURLConnection *)connection
     didReceiveData: (NSData *)data
{
    if (connection == self.collectionConnection)
        [self.receivedData appendData: data];
}

// -----------------------------------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == self.collectionConnection)
    {
        [self parseJSONResult];
    }
    [self.HUD hide:YES];
    
    [self cancelConnection: connection];
}

// -----------------------------------------------------------------------------

- (void)connection: (NSURLConnection *) connection
  didFailWithError: (NSError *) error
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"EROARE!";
    hud.detailsLabelText = [NSString stringWithFormat:@"Conectare la server esuată!"];
    NSLog(@"%@",error);
    
    hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                            size: 14];
    hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];

    [self cancelConnection: connection];
    
    [self performSelector: @selector(goBack)
               withObject: nil
               afterDelay: 2];
    
}

// -----------------------------------------------------------------------------

- (void) cancelConnection:(NSURLConnection*) connection
{
    if (connection == self.collectionConnection)
    {
        [self.HUD hide:YES];
    
        [self.collectionConnection cancel];
        self.collectionConnection = nil;
        self.receivedData = nil;
    }
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
#pragma mark - MBProgressHUDDelegate
// -----------------------------------------------------------------------------

- (void) hudWasHidden: (MBProgressHUD *)hud
{
    
    // Remove HUD from screen when the HUD was hidded
    [self.HUD removeFromSuperview];
	self.HUD = nil;
}

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
   #pragma mark - TEDArticlesScrollerViewController delegate
// -----------------------------------------------------------------------------

- (void)articlesViewController: (TEDArticlesScrollerViewController*) articlesViewController
          didSelectItemAtIndex: (NSInteger) index
{
    TEDArticleModelObject* object = [collection objectAtIndex:index];
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL: [[NSURL alloc] initWithArticleID:
                                          [[object objectForKey: @"id_art"]integerValue]]
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
    request.HTTPMethod = @"GET";

    TEDWebViewController *webView = [[TEDWebViewController alloc]initWithRequest:request];
    
    [self.navigationController pushViewController: webView
                                         animated: YES];
}

// -----------------------------------------------------------------------------

- (MGStyledBox *) boxAtIndex: (NSUInteger)index
{
    MGStyledBox *box = [MGStyledBox box];
   
    // fonts styles
    UIFont *headerFont = [UIFont fontWithName: @"OpenSans-Bold"
                                         size: 14];
    UIFont *shortContentFont = [UIFont fontWithName: @"OpenSans-SemiboldItalic"
                                               size: 12];
    UIFont *catAndDateFont = [UIFont fontWithName: @"OpenSans-Semibold"
                                             size: 11];
    // ------
    
    TEDArticleModelObject * object = [collection objectAtIndex: index];
   
    // article image, if exist
    if (object.articleImageURL != NULL)
    {
        TEDLazyImageView *imageView =
        [[TEDLazyImageView alloc] initWithFrame: CGRectMake(0, 0, 296, 116)
                                         andURL: object.articleImageURL];
        
        MGBoxLine *line = [MGBoxLine lineWithLeft: imageView right: nil];
        line.linePadding = 4;
        line.height = 124;
        line.itemPadding = 0;
        [box.topLines addObject:line];
    }
    
    if([object objectForKey: @"title"])
    {
    NSString *title = [[NSString alloc]initWithFormat: @"%@",
                       [object objectForKey: @"title"]];
        title = [title decodeHTMLEntities:title];
        title = [title stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
        
    MGBoxLine *titleLine = [MGBoxLine multilineWithText: title
                                                   font: headerFont
                                                padding: 14];
   
    titleLine.linePadding = 6;
    titleLine.itemPadding = 0;
    [box.middleLines addObject: titleLine];
    
    }
    
    if([object objectForKey: @"content"])
    {
    
    // short cotent of article
    NSString *shortContent = [[NSString alloc]initWithFormat: @"%@",
                              [object objectForKey: @"content"]];
    shortContent = [shortContent decodeHTMLEntities: shortContent];
    shortContent = [shortContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];    
    
    MGBoxLine *shortContentLine = [MGBoxLine multilineWithText: shortContent
                                                          font: shortContentFont
                                                       padding: 14];
    shortContentLine.linePadding = 6;
    shortContentLine.itemPadding = 0;
    [box.middleLines addObject: shortContentLine];
    
    }
    
    if([object objectForKey: @"cat_name"])
    {
    
    // category & date (info line)
    NSString *category = [[NSString alloc]initWithFormat: @"Categorie:  %@",
                              [object objectForKey: @"cat_name"]];
   
    NSString *date = [[NSString alloc]initWithFormat: @"Data publicării:  %@",
                          [object objectForKey: @"date"]];
   
    MGBoxLine *infoLine = [MGBoxLine lineWithLeft: category right: date];
        infoLine.alpha = 0.6;

    infoLine.font = catAndDateFont;
    infoLine.height = 24;
    [box.bottomLines addObject: infoLine];
    
    }
    return box;
}

// -----------------------------------------------------------------------------

- (CGRect) scrollViewDimensions
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    return CGRectMake(0, 0, screenWidth, screenHeight -
                      26 - self.navigationController.navigationBar.frame.size.height);
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
    // for refresh
    
    [self.currentCategory setString: index];
    self.currentPageNumber = 1;
    
    if ([index isEqual: @"all"])
    {
        [self loadCollectionAtURL: [[NSURL alloc]initWithCategoryID: NSNotFound
                                                      andPageNumber: 1]];
    } else
            [self loadCollectionAtURL: [[NSURL alloc]initWithCategoryID: [index integerValue]
                                                          andPageNumber: 1]];
    
    self.searchResultsIsShow = NO;
}

// -----------------------------------------------------------------------------

- (void) menuIsInitSuccessful:(TEDHorizontalMenu*) menu
{
    [menu setSelectedElementAtIndex: 0
                           animated: YES];
    self.menuIsInit = YES;
    menu.alpha = 0;
    [UIView animateWithDuration: 0.4 animations:^{menu.alpha = 1;}];
}

// -----------------------------------------------------------------------------

- (void) dealloc
{
    self.collection = nil;
    self.collectionConnection = nil;
    self.articlesScrollerView = nil;
    self.catMenu = nil;
    self.receivedData = nil;
}

// -----------------------------------------------------------------------------
-(void) goBackToPreviousPage
{
    if (!self.toolDrawerView.isOpen && !self.searchResultsIsShow)
    {
    if (self.paginator.paginatorChainIsInit)
    {
        if (self.currentPageNumber > 1)
        {
            self.currentPageNumber -= 1;
            NSUInteger categoryID;
            if([self.currentCategory isEqual:@"all"])
            {
                categoryID = NSNotFound;
            } else
                categoryID = [self.currentCategory integerValue];
            
            [self loadCollectionAtURL:
             [[NSURL alloc]initWithCategoryID: categoryID
                                andPageNumber: self.currentPageNumber]];
        }
        else {
                // show allert - no more pages
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: self.navigationController.view
                                                          animated: YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"";
                hud.detailsLabelText = [NSString stringWithFormat:@"Vă aflați pe prima pagina din categoria dată."];
                hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                                        size: 14];
                hud.dimBackground = YES;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
             }
    } else self.paginator = [[TEDPaginatorModel alloc] initModel];
  }
}

-(void) goForvardToNextPage
{
    if (!self.toolDrawerView.isOpen && !self.searchResultsIsShow)
    {

    if (self.paginator.paginatorChainIsInit)
    {
        NSInteger pageNumber = [self.paginator numberOfPagesForCategory: self.currentCategory];
        
        if (self.currentPageNumber < pageNumber) {
            
            self.currentPageNumber += 1;
            NSUInteger categoryID;
            if([self.currentCategory isEqual:@"all"])
            {
                categoryID = NSNotFound;
            } else
                categoryID = [self.currentCategory integerValue];
                
            [self loadCollectionAtURL:
             [[NSURL alloc]initWithCategoryID: categoryID
                                andPageNumber: self.currentPageNumber]];
        }
        else {
            // show allert - no more pages
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                                      animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"";
            if (self.currentPageNumber == 1) {
                hud.detailsLabelText = [NSString stringWithFormat:@"Vă aflați pe pagina numărul %d din categoria dată, care, parise este prima și ultima.",self.currentPageNumber];
            }
            else{
                hud.detailsLabelText = [NSString stringWithFormat:@"Vă aflați pe pagina numărul %d din categoria dată, care, parise este ultima.",self.currentPageNumber];
            }
            hud.detailsLabelFont =  [UIFont fontWithName: @"OpenSans-Semibold"
                                                    size: 14];
            hud.dimBackground = YES;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
    
    } else self.paginator = [[TEDPaginatorModel alloc] initModel];
  }
}

@end

