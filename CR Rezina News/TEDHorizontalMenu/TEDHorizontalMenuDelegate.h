//
//  TEDHorizontalMenuDelegate.h
//  HorizontalMenu
//
//  Created by Stefan Popa on 30.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  TEDHorizontalMenu;

@protocol TEDHorizontalMenuDelegate <NSObject>

@required
- (void) menuItemSelectedAtIndex:(NSString*) index;
- (void) menuItemSelectedAtIndexNamed:(NSString*) index;
- (void) menuIsInitSuccessful:(TEDHorizontalMenu*) menu;

@end
