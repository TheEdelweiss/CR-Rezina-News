//
//  UIImage+TEDScale.m
//  CR Rezina
//
//  Created by Stefan Popa on 07.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "UIImage+TEDScale.h"

@implementation UIImage (TEDScale)

-(UIImage *) scaleToSize: (CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
