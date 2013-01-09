//
//  TEDArticlesViewControllerDataSource.h
//  CR Rezina
//
//  Created by Stefan Popa on 06.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MGStyledBox;

@protocol TEDArticlesViewControllerDataSource <NSObject>
@required
- (MGStyledBox *) boxAtIndex: (NSUInteger)index;
- (CGRect) scrollViewDimensions;
- (NSUInteger) numberOfBoxesInScroller;

@end
