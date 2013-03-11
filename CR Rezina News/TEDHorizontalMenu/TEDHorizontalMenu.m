//
//  TEDHorizontalMenu.m
//  HorizontalMenu
//
//  Created by Stefan Popa on 28.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//
#define baseButtonTag 10000

#import "TEDHorizontalMenu.h"
#import "JSONKit.h"


@implementation TEDHorizontalMenu

@synthesize items, categoryIDs;
@synthesize itemSelectedDelegate;
@synthesize itemCount;
@synthesize receivedData;
@synthesize collectionConnection;
@synthesize itemsTitles;
@synthesize wasBuild;

-(id) init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(void) startWithURL:(NSURL *) URL
{
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL: URL
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
    
    request.HTTPMethod = @"GET";
    
    self.collectionConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                delegate: self];
    if (self.collectionConnection)
        self.receivedData = [NSMutableData data];
    
    if([self tryToBuildWithContentOfLocalFile])
    {
        [self buildSelf];
        self.wasBuild = YES;
    }
    
}

-(void) applyBaseSettings{

     //[self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
     
     self.bounces = NO;
     self.scrollEnabled = YES;
     self.alwaysBounceHorizontal = YES;
     self.alwaysBounceVertical = NO;
     self.showsHorizontalScrollIndicator = NO;
     self.showsVerticalScrollIndicator = NO;
     }

- (BOOL) tryToBuildWithContentOfLocalFile
{
    //categoriesMenuList.plist
    NSString* menuFilePath = [[NSBundle mainBundle] pathForResource: @"categoriesMenuList"
                                                             ofType: @"plist"];
    
    NSArray *dict = [[NSArray alloc] initWithContentsOfFile: menuFilePath];
                             
    if([dict count] > 0)
    {
        self.itemsTitles = [[NSMutableArray alloc] init];
        self.categoryIDs = [[NSMutableArray alloc] init];
        
        [self.itemsTitles addObject: @"Toate"];
        [self.categoryIDs addObject: @"all"];

        
        for (NSDictionary* attributes in dict)
        {
            [self.itemsTitles addObject: [attributes objectForKey: @"cat_name"]];
            [self.categoryIDs addObject: [attributes objectForKey: @"cat_id"]];
        }
     }
    else return NO;

    return YES;
}

-(void) buildSelf
{
    [self applyBaseSettings];
    //[self.categoryIDs removeAllObjects];
    self.itemCount = [self.itemsTitles count];
    
    UIFont *buttonFont = [UIFont fontWithName: @"OpenSans-Bold"
                                         size: 13];
    int buttonPadding = 25;
    
    int tag = baseButtonTag;
    int xPos = 0;
    
    for(int i = 0 ; i < self.itemCount; i ++)
    {
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setTitle: [self.itemsTitles objectAtIndex: i]
                      forState: UIControlStateNormal];
        customButton.titleLabel.font = buttonFont;
        
        [customButton setTitleShadowColor: [UIColor colorWithWhite: 0.0
                                                       alpha: 0.6]
                           forState: UIControlStateNormal];
        
        customButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        customButton.tag = tag++;
        [customButton addTarget: self
                         action: @selector(buttonIsTapped:)
               forControlEvents: UIControlEventTouchUpInside];
        
        NSString *title = [self.itemsTitles objectAtIndex: i];
        
        int buttonWidth = [title sizeWithFont: customButton.titleLabel.font
                            constrainedToSize: CGSizeMake(150, 19)
                                lineBreakMode: UILineBreakModeClip].width;
        
        customButton.frame = CGRectMake(xPos, 0, buttonWidth + buttonPadding, 19);
        xPos += buttonWidth;
        xPos += buttonPadding;
        
        UIImage *resizableButton = [[UIImage imageNamed:@"categoryButoonBG.png" ] resizableImageWithCapInsets: UIEdgeInsetsMake(10, 5, 10, 5)];
        [customButton setBackgroundImage:resizableButton
                                forState:UIControlStateSelected];
        //customButton.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
   
        
        [self addSubview: customButton];
    }
    

    self.contentSize = CGSizeMake(xPos, 36);
    [self layoutSubviews];
    
    [self.itemSelectedDelegate menuIsInitSuccessful: self];
    
}


-(void) setSelectedElementAtIndex:(int) index animated:(BOOL) animated
{
    UIButton *thisButton = (UIButton*) [self viewWithTag: index + baseButtonTag];
    thisButton.selected = YES;
    [self setContentOffset:CGPointMake(thisButton.frame.origin.x, 0) animated:animated];
    //[self.itemSelectedDelegate horizontalMenu:self itemSelectedAtIndex: index];
}



-(void) buttonIsTapped:(id) sender
{
    UIButton *button = (UIButton*) sender;
    
    for(int i = 0; i < self.itemCount; i++)
    {
        UIButton *thisButton = (UIButton*) [self viewWithTag: i + baseButtonTag];
        
        if(i + baseButtonTag == button.tag)
            thisButton.selected = YES;
        else
            thisButton.selected = NO;
    }
    NSUInteger index = button.tag - baseButtonTag;
    [self.itemSelectedDelegate menuItemSelectedAtIndex: [self.categoryIDs objectAtIndex: index]];
    [self.itemSelectedDelegate menuItemSelectedAtIndexNamed: [self.itemsTitles objectAtIndex: index]];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegete
//------------------------------------------------------------------------------
- (void)connection: (NSURLConnection *) connection
didReceiveResponse: (NSURLResponse *) response
{
    NSInteger connectionStatus = [(NSHTTPURLResponse*)response statusCode];
    
    if(connectionStatus == 200) {
    } else {
        if (connection == collectionConnection)
        {
         [self cancelConnection: connection];
        }
    }
}

// -----------------------------------------------------------------------------

- (void)connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
    if (connection == self.collectionConnection)
        [receivedData appendData:data];
}

// -----------------------------------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        if (connection == collectionConnection) {
        [self parseJSONResult];
    }
    
    [self cancelConnection: connection];
}

// -----------------------------------------------------------------------------

- (void)connection: (NSURLConnection *)connection
  didFailWithError: (NSError *)error
{
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


- (void) parseJSONResult
{
    NSString* resultString = [[NSString alloc] initWithData: self.receivedData
                                                   encoding: NSUTF8StringEncoding];
    @try {
           self.items = [resultString objectFromJSONString];
         }
         @catch (NSException * e)
                 {
        
                 }
    
    if(self.items) {
        if(self.wasBuild)
        {
            if([self.itemsTitles count] != [self.items count])
            {
                // rebuild menu
                self.itemsTitles = [[NSMutableArray alloc] init];
                self.categoryIDs = [[NSMutableArray alloc] init];
                
                [self.itemsTitles addObject: @"Toate"];
                [self.categoryIDs addObject: @"all"];
                
                for (NSDictionary* attributes in self.items)
                {
                    [self.itemsTitles addObject: [attributes objectForKey: @"cat_name"]];
                    
                    [self.categoryIDs addObject: [attributes objectForKey: @"cat_id"]];
                }
                
                [self removeSubviews];
                [self buildSelf];
                
                NSString* menuFilePath = [[NSBundle mainBundle] pathForResource: @"categoriesMenuList"
                                                                         ofType: @"plist"];
                
                [self.items writeToFile: menuFilePath
                             atomically: YES];

            }
        }
        else {
            self.itemsTitles = [[NSMutableArray alloc] init];
            self.categoryIDs = [[NSMutableArray alloc] init];
            
            [self.itemsTitles addObject: @"Toate"];
            [self.categoryIDs addObject: @"all"];
            
            for (NSDictionary* attributes in self.items)
            {
                [self.itemsTitles addObject: [attributes objectForKey: @"cat_name"]];
                [self.categoryIDs addObject: [attributes objectForKey: @"cat_id"]];
            }
            [self buildSelf];
            
            NSString* menuFilePath = [[NSBundle mainBundle] pathForResource: @"categoriesMenuList"
                                                                     ofType: @"plist"];
            
            [self.items writeToFile: menuFilePath
                         atomically: YES];
        }

    }
    
}


- (void) removeSubviews
{
    // remove all subview's from self
    for (UIView *view in self.subviews)
    {
        if (![view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
}

// -----------------------------------------------------------------------------

@end
 
