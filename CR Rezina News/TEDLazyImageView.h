//
//  TEDLazyImageView.h
//  CR Rezina
//
//  Created by Stefan Popa on 07.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+TEDScale.h"

@interface TEDLazyImageView : UIImageView
{
    NSMutableData *loadedData;
}

- (id)initWithFrame:(CGRect)frame andURL:(NSURL *) url;
- (void)loadWithURL:(NSURL *) url;

@end
