//
//  UINavigationBar+TEDShadow.h
//  CR Rezina
//
//  Created by Stefan Popa on 08.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (TEDShadow)

- (void)dropShadowWithOffset: (CGSize)    offset
                      radius: (CGFloat)   radius
                       color: (UIColor *) color
                     opacity: (CGFloat)   opacity;

@end
