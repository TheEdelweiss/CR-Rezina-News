//
//  TEDContactsViewController.m
//  CR Rezina
//
//  Created by Stefan Popa on 16.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDContactsViewController.h"
#import "MGBox.h"

@interface TEDContactsViewController ()

@end

@implementation TEDContactsViewController
// -----------------------------------------------------------------------------
@synthesize scrollerIsInit,
            scrollerController,
            HUD, collection,
            receivedData,
            collectionConnection;
// -----------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.collection = [[NSMutableArray alloc] init];
        
        // go home button
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"home.png"]
                                                                       style: UIBarButtonItemStylePlain
                                                                      target: self
                                                                      action: @selector(goBack)];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
    }
    return self;
}
// -----------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // go home button
    // get screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // ---------------
    
    // frame for articles scroller
    CGRect scrollerFrame =
    CGRectMake(0, 0, screenWidth, screenHeight -
               self.navigationController.navigationBar.frame.size.height);
    // ---------------
    
    // init scroller view
    self.scrollerController =
    [[TEDMGBoxScrollerView alloc]initWithFrame: scrollerFrame];
    [self.scrollerController setScrollerDataSource: self];
    [self.scrollerController setScrollerDelegate: self];
    
    // put to articles view
    [self.view addSubview: self.scrollerController];
    // ---------------
    
    self.view.backgroundColor =[UIColor clearColor];
    
    // start load collection
    [self loadCollectionAtURL: [[NSURL alloc] initWithAllContactsEntities]];
}

// -----------------------------------------------------------------------------

- (void) loadCollectionAtURL: (NSURL *) URL
{
    
    [self.collection removeAllObjects];
    
    self.HUD = [[MBProgressHUD alloc] initWithView: self.navigationController.view];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview: self.HUD];
    [self.HUD show:YES];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// -----------------------------------------------------------------------------
- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
// -----------------------------------------------------------------------------

- (void) backToTitles
{
    // start load collection
    [self loadCollectionAtURL: [[NSURL alloc] initWithAllContactsEntities]];
    // go home button
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"home.png"]
                                                                   style: UIBarButtonItemStylePlain
                                                                  target: self
                                                                  action: @selector(goBack)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
    
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
        return;
    }
    
    for (NSDictionary* attributes in myDict)
    {
        TEDContactsModel* modelObject =
        [[TEDContactsModel alloc] initWithAttributes: attributes];
        
        // add to colection NSArray
        [self.collection addObject: modelObject];
    }
    
    if(!self.scrollerIsInit)
    {
        [self.scrollerController buildAndStart];
        self.scrollerIsInit = YES;
    }
        else [self.scrollerController reloadData];
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
        self.HUD.mode = MBProgressHUDModeDeterminate;
        
    } else {
        if (connection == self.collectionConnection)
        {
            self.HUD.customView =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"checkmark.png"]];
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.delegate = self;
            self.HUD.labelText = @"EROARE!";
            self.HUD.detailsLabelText =
            [NSString stringWithFormat:@"Server error code: %i",connectionStatus];
            self.HUD.dimBackground = YES;
            [self.HUD hide: YES afterDelay: 1.5];
            
            [self cancelConnection: connection];
            // ------------
            
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
	self.HUD.customView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"checkmark.png"]];
    
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.dimBackground = YES;
    self.HUD.delegate = self;
    self.HUD.labelText = @"EROARE!";
    self.HUD.detailsLabelText = @"Conectare la server esuata!";
    [self.HUD hide:YES afterDelay: 1.5];
    
    [self cancelConnection: connection];
    
}

// -----------------------------------------------------------------------------

- (void) cancelConnection:(NSURLConnection*) connection
{
    if (connection == self.collectionConnection)
    {
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
    TEDContactsModel* object = [collection objectAtIndex: index];
    if ([object objectForKey: @"name"])
    {
        NSInteger ID = [[object objectForKey: @"id"] integerValue];
        
        // start load collection
        [self loadCollectionAtURL: [[NSURL alloc] initWithContactEntityID: ID]];
        
        // go home button
        UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"list.png"]
                                                                       style: UIBarButtonItemStylePlain
                                                                      target: self
                                                                      action: @selector(backToTitles)];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject: homeButton];
    }
    
}

// -----------------------------------------------------------------------------

- (MGStyledBox *) boxAtIndex: (NSUInteger)index
{
    MGStyledBox *box = [MGStyledBox box];
    
    // fonts styles
    UIFont *headerFont = [UIFont fontWithName: @"OpenSans-Bold"
                                         size: 14];
    // ------
    
    TEDContactsModel * object = [collection objectAtIndex: index];
    
    if([object objectForKey: @"name"])
    {
        NSString *title = [NSString alloc];
        if(![@"Superior" isEqual: [object objectForKey: @"name"]])
        {
         title = [[NSString alloc]initWithFormat: @"Contacte: %@",
                           [object objectForKey: @"name"]];
        } else
        {
           title = [[NSString alloc]initWithFormat: @"Contacte: Președinte"];
        }
       
        title = [title decodeHTMLEntities:title];
        
        MGBoxLine *titleLine = [MGBoxLine multilineWithText: title
                                                       font: headerFont
                                                    padding: 14];
        
        titleLine.linePadding = 6;
        titleLine.itemPadding = 0;
        [box.middleLines addObject: titleLine];
    }
     else if([object objectForKey: @"government_entity_name"])
          {
              UIFont *shortContentFont = [UIFont fontWithName: @"OpenSans-SemiboldItalic"
                                                         size: 12];
              
              if([object objectForKey: @"government_entity_name"])
              {
                  NSString *title = [[NSString alloc]initWithFormat: @"%@",
                                     [object objectForKey: @"government_entity_name"]];
                  title = [title decodeHTMLEntities:title];
                  
                  MGBoxLine *titleLine = [MGBoxLine multilineWithText: title
                                                                 font: headerFont
                                                              padding: 14];
                  
                  titleLine.linePadding = 6;
                  titleLine.itemPadding = 0;
                  [box.middleLines addObject: titleLine];
                  
              }
              
              if([object objectForKey: @"government_entity_contacts"])
              {
                  
                  // short cotent of article
                  NSString *shortContent = [[NSString alloc]initWithFormat: @"%@",
                                            [object objectForKey: @"government_entity_contacts"]];
                  shortContent = [shortContent decodeHTMLEntities:shortContent];
                  
                  MGBoxLine *shortContentLine = [MGBoxLine multilineWithText: shortContent
                                                                        font: shortContentFont
                                                                     padding: 14];
                  shortContentLine.linePadding = 6;
                  shortContentLine.itemPadding = 0;
                  [box.middleLines addObject: shortContentLine];
              }
          }
    
    return box;
}

// -----------------------------------------------------------------------------

- (CGRect) scrollViewDimensions
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    return CGRectMake(0, 0, screenWidth, screenHeight - self.navigationController.navigationBar.frame.size.height);
}

// -----------------------------------------------------------------------------

- (NSUInteger) numberOfBoxesInScroller
{
    return [self.collection count];
    
}

// -----------------------------------------------------------------------------

@end
