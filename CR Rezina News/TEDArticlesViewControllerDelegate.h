//
//  TEDArticlesViewControllerDelegate.h
//  CR Rezina
//
//  Created by Stefan Popa on 06.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TEDArticlesScrollerViewController;
@protocol TEDArticlesViewControllerDelegate <NSObject>
@required

- (void)articlesViewController: (id)articlesViewController
          didSelectItemAtIndex: (NSInteger)index;

@end
