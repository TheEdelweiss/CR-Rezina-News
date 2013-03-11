//
//  TEDPaginatorModel.m
//  CR Rezina
//
//  Created by Stefan Popa on 22.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDPaginatorModel.h"
#import "JSONKit.h"
#import "NSURL+TEDWebAPIURL.h"

@implementation TEDPaginatorModel

@synthesize paginatorChain,
            totalArticlesCount,
            articlesPerPage,
            collectionConnection,
            receivedData;

//------------------------------------------------------------------------------
- (id) initModel
{
    if (self = [super init])
    {
        self.paginatorChain = [[NSMutableArray alloc] init];
        [self startToLoadData];
    }
    
    return self;
}
//------------------------------------------------------------------------------

-(void) startToLoadData
{
    NSMutableURLRequest* request = 
    [NSMutableURLRequest requestWithURL: [[NSURL alloc] initWithPaginatorInfo]
                            cachePolicy: NSURLRequestUseProtocolCachePolicy
                        timeoutInterval: 15.0];
   
    request.HTTPMethod = @"GET";
    
    self.collectionConnection = [[NSURLConnection alloc] initWithRequest: request
                                                                delegate: self];
    if (self.collectionConnection)
        self.receivedData = [NSMutableData data];
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
#pragma mark - NSURLConnectionDelegete
//------------------------------------------------------------------------------
- (void)connection: (NSURLConnection *) connection
didReceiveResponse: (NSURLResponse *) response
{
    NSInteger connectionStatus = [(NSHTTPURLResponse*)response statusCode];
    
    if(connectionStatus == 200)
    {
        
    }
    else {
           self.paginatorChainIsInit = NO;
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
    if (connection == collectionConnection)
       {
         [self parseJSONResult];
       }
    
    [self cancelConnection: connection];
}

// -----------------------------------------------------------------------------

- (void)connection: (NSURLConnection *)connection
  didFailWithError: (NSError *)error
{
    [self cancelConnection: connection];
    self.paginatorChainIsInit = NO;
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
    
    // NSLog(@"%@", resultString);
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    
    @try {
          dictionary = [resultString objectFromJSONString];
    }
    @catch (NSException * e)
    {
        
    }
    
    if(dictionary)
    {
     for (NSDictionary* attributes in dictionary)
         {
             
             if([attributes objectForKey:@"cat_id"])
             {
                 [self.paginatorChain addObject: attributes];
                 
             }
             else if ([attributes objectForKey: @"total_article_count"])
                     {
                         self.totalArticlesCount = [[attributes objectForKey: @"total_article_count"] integerValue];
                         
                     }
             else if ([attributes objectForKey: @"articles_per_page"])
             {
                 self.articlesPerPage = [[attributes objectForKey: @"articles_per_page"] integerValue];
             }
        }
        self.paginatorChainIsInit = YES;
    }
}

// -----------------------------------------------------------------------------
- (NSInteger) numberOfPagesForCategory : (id) category
{
    if(self.paginatorChainIsInit)
    {
        NSInteger pageNumber = 0;
        
        if([(NSString*)category isEqual:@"all"])
        {
            if((self.totalArticlesCount%10) !=0)
               {
                   pageNumber += 1;
               }
            pageNumber += self.totalArticlesCount/10;
            
            return pageNumber;
        }
        
        
    for (NSDictionary *element in self.paginatorChain)
    {
            if ([category integerValue] == [[element objectForKey: @"cat_id"] integerValue])
            {
                NSInteger articlesCounter = [[element objectForKey: @"article_count"] integerValue];
            
                if((articlesCounter%10) !=0)
                {
                    pageNumber += 1;
                }
                pageNumber += articlesCounter/10;
                return pageNumber;
            }
    }
}
    return NSNotFound;
}

@end
