//
//  UINavigationBar+TEDShadow.m
//  CR Rezina
//
//  Created by Stefan Popa on 08.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "UINavigationBar+TEDShadow.h"

@implementation UINavigationBar (TEDShadow)

- (void) dropShadowWithOffset: (CGSize)    offset
                       radius: (CGFloat)   radius
                        color: (UIColor *) color
                      opacity: (CGFloat)   opacity
{    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
}

@end
