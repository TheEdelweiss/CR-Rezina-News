//
//  NSURL+TEDWebAPIURL.h
//  CR Rezina
//
//  Created by Stefan Popa on 31.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (TEDWebAPIURL)

- (NSURL *) initWithCategoryID: (NSUInteger) categoryID
                 andPageNumber: (NSUInteger) pageNumber;

- (NSURL *) initWithSearchKeywords: (NSString *) searchKeywords;
- (NSURL *) initWithAllCategories: (NSUInteger) allCategories;
- (NSURL *) initWithArticleID: (NSUInteger) articleID;
- (NSURL *) initWithImageAtArticleID: (NSUInteger) articleID;
- (NSURL *) initWithEffectiveURLOfArticleAtIndex: (NSUInteger) articleID;

- (NSURL *) initWithAllContactsEntities;
- (NSURL *) initWithContactEntityID: (NSUInteger) contactID;

- (NSURL *) initWithPaginatorInfo;

@end
