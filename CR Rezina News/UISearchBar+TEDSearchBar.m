//
//  UISearchBar+TEDSearchBar.m
//  CR Rezina
//
//  Created by Stefan Popa on 04.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "UISearchBar+TEDSearchBar.h"

@implementation UISearchBar (TEDSearchBar)

- (id) initWithFrame: (CGRect) frame
        andPlaceholder: (NSString*) placeholder
{
    self = [self initWithFrame: frame];
    
    [[[self subviews] objectAtIndex:0] setAlpha:0.0];
    self.placeholder = placeholder;
    
    // remove icon
    ((UITextField*)[[self subviews] objectAtIndex:1]).leftView = nil;

    
    
    return self;
}

@end
