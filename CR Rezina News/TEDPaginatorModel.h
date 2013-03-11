//
//  TEDPaginatorModel.h
//  CR Rezina
//
//  Created by Stefan Popa on 22.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

struct paginatorEntity
    {
    int categoryID;
    int totalPages;
    };

@interface TEDPaginatorModel : NSObject

@property (nonatomic, strong) NSMutableArray *paginatorChain;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *collectionConnection;

// flag
@property BOOL paginatorChainIsInit;

@property int totalArticlesCount;
@property int articlesPerPage;

- (id) initModel;
- (NSInteger) numberOfPagesForCategory : (id)category;


@end
