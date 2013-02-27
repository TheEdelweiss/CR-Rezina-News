//
//  NSURL+TEDWebAPIURL.m
//  CR Rezina
//
//  Created by Stefan Popa on 31.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "NSURL+TEDWebAPIURL.h"

@implementation NSURL (TEDWebAPIURL)
// -----------------------------------------------------------------------------
- (NSString *) baseAPIURL
{
    return @"http://consiliu.rezina.md/api";
}

// -----------------------------------------------------------------------------

- (NSString *) baseWEBURL
{
    return @"http://consiliu.rezina.md";
}

// -----------------------------------------------------------------------------

- (NSURL *) initWithPaginatorInfo
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/category/info",self.baseAPIURL];
    
    return [NSURL URLWithString: URL];
}
// -----------------------------------------------------------------------------
- (NSURL *) initWithCategoryID: (NSUInteger) categoryID
                    andPageNumber: (NSUInteger) pageNumber
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/article",self.baseAPIURL];
        if (categoryID != NSNotFound)
            [URL appendFormat: @"/category/%d", categoryID];
            else
                [URL appendFormat: @"/category/all"];
    
        if (pageNumber != NSNotFound)
            [URL appendFormat: @"/page/%d", pageNumber];
            else
                [URL appendFormat: @"/page/1"];
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithArticleID: (NSUInteger) articleID
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/article",self.baseAPIURL];
    
    if (articleID != NSNotFound)
        [URL appendFormat: @"/%d", articleID];
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithSearchKeywords: (NSString *) searchKeywords
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/search/articles",self.baseAPIURL];

      searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString: @" "
                                                                 withString: @"_"];
    
    /*
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"ă" withString:	@"&#259;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"Ă" withString:	@"&#258;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"â" withString:	@"&#226;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"Â" withString:	@"&#194;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"î" withString:	@"&#238;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"Î" withString:	@"&#206;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"ș" withString:	@"&#351;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"Ș" withString:	@"&#350;"];
    searchKeywords = [searchKeywords stringByReplacingOccurrencesOfString:@"ţ" withString:	@"&#355;"];
    
   */
    
    
    CFStringRef newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(searchKeywords), NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8);
    
    [URL appendFormat: @"/%@", newString];
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithAllCategories: (NSUInteger) allCategories
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/category",self.baseAPIURL];
    
    if (allCategories != NSNotFound)
    {
        [URL appendFormat: @"/%d", allCategories];
    }
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithImageAtArticleID: (NSUInteger) articleID
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@/content_imgs/articles_imgs",self.baseWEBURL];
    
    if (articleID != NSNotFound)
    {
        [URL appendFormat: @"/%d/thumb.jpg", articleID];
    }
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithEffectiveURLOfArticleAtIndex: (NSUInteger) articleID
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@",self.baseWEBURL];
    
    if (articleID != NSNotFound)
    {
        [URL appendFormat: @"/view.php?art_id=%d", articleID];
    }
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithAllContactsEntities
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@",self.baseAPIURL];

    [URL appendFormat: @"/contacts/"];
    
    return [NSURL URLWithString: URL];
}

// -----------------------------------------------------------------------------
- (NSURL *) initWithContactEntityID: (NSUInteger) contactID
{
    NSMutableString *URL =
    [[NSMutableString alloc] initWithFormat: @"%@",self.baseAPIURL];
    
    if (contactID != NSNotFound)
    {
        [URL appendFormat: @"/contacts/%d", contactID];
    }
    
    return [NSURL URLWithString: URL];
}

@end
