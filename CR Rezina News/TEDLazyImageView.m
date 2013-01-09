//
//  TEDLazyImageView.m
//  CR Rezina
//
//  Created by Stefan Popa on 07.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDLazyImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TEDLazyImageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//------------------------------------------------------------------------------

- (id)initWithFrame: (CGRect)frame andURL: (NSURL *) url
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
	    loadedData = [[NSMutableData alloc] init];
        // background
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
        
        // shadow & corners
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1];
        
        self.layer.shadowColor = [UIColor colorWithWhite: 0.12 alpha: 1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0.5);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 1;

        [self loadWithURL: url];
    }
    
    return self;
}

//------------------------------------------------------------------------------

- (void)loadWithURL:(NSURL *)url
{
	self.alpha = 0.01;
    NSURLConnection *connection =
    [NSURLConnection connectionWithRequest: [NSURLRequest requestWithURL:url]
                                  delegate: self];
    [connection start];
}

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegete
//------------------------------------------------------------------------------

- (void)connection: (NSURLConnection *) connection
didReceiveResponse: (NSURLResponse *) response
{
    NSInteger connectionStatus = [(NSHTTPURLResponse*)response statusCode];
    
    if(connectionStatus == 200){
        
        [loadedData setLength:0];
    
    } else [connection cancel];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel];
}

//------------------------------------------------------------------------------

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [loadedData appendData: data];
}

//------------------------------------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Get frame size
    // CGSize size = self.frame.size;
    
    // Scale the image
    self.image = [[[UIImage alloc] initWithData: loadedData] scaleToSize: self.frame.size];
    
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.0;
    [UIView commitAnimations];
    
   
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
