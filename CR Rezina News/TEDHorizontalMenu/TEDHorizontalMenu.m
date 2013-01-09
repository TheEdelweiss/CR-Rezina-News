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

-(id) init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void) startWithURL:(NSURL *)URL andPOSTParams: (NSString *)params
{
    NSMutableURLRequest* request =
    [NSMutableURLRequest requestWithURL: URL
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params dataUsingEncoding: NSUTF8StringEncoding];
    
    
    self.collectionConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                delegate: self];
    if (self.collectionConnection)
        self.receivedData = [NSMutableData data];
}

-(void) applyBaseSettings{

     [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
     self.bounces = NO;
     self.scrollEnabled = YES;
     self.alwaysBounceHorizontal = YES;
     self.alwaysBounceVertical = NO;
     self.showsHorizontalScrollIndicator = NO;
     self.showsVerticalScrollIndicator = NO;
     }


-(void) buildSelf
{
    
    [self applyBaseSettings];
    [self.categoryIDs removeAllObjects];
    self.itemCount = [self.items count];
    
    UIFont *buttonFont = [UIFont boldSystemFontOfSize:13];
    int buttonPadding = 25;
    
    int tag = baseButtonTag;
    int xPos = 0;
    
    NSMutableArray *itemsTitles = [[NSMutableArray alloc] init];
    self.categoryIDs = [[NSMutableArray alloc] init];
    
    for (NSDictionary* attributes in self.items) {
        
        [itemsTitles addObject: [attributes objectForKey: @"cat_name"]];
        [self.categoryIDs addObject: [attributes objectForKey: @"cat_id"]];
    }
    
    
    for(int i = 0 ; i < self.itemCount; i ++)
    {
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setTitle: [itemsTitles objectAtIndex: i]
                      forState: UIControlStateNormal];
        customButton.titleLabel.font = buttonFont;
        
        
        customButton.tag = tag++;
        [customButton addTarget: self
                         action: @selector(buttonIsTapped:)
               forControlEvents: UIControlEventTouchUpInside];
        
        NSString *title = [itemsTitles objectAtIndex: i];
        
        int buttonWidth = [title sizeWithFont: customButton.titleLabel.font
                            constrainedToSize: CGSizeMake(150, 36)
                                lineBreakMode: UILineBreakModeClip].width;
        
        customButton.frame = CGRectMake(xPos, 0, buttonWidth + buttonPadding, 36);
        xPos += buttonWidth;
        xPos += buttonPadding;
        
        
        [customButton setBackgroundColor:[UIColor colorWithRed: 0.25
                                                         green: 0.32
                                                          blue: 0.39
                                                         alpha: 1]];
        
        //customButton.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
   
        
        [self addSubview: customButton];
    }
    

    self.contentSize = CGSizeMake(xPos, 36);
    [self layoutSubviews];
}


-(void) setSelectedElementAtIndex:(int) index animated:(BOOL) animated
{
    UIButton *thisButton = (UIButton*) [self viewWithTag:index + baseButtonTag];
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
        //NSLog(@"Server respond OK!");
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
    @catch (NSException * e) {
        
    }
    
    if(self.items) {
        [self buildSelf];
    }
    
}

// -----------------------------------------------------------------------------

@end
 
