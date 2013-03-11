//
//  TEDArticleModelObject.h
//  CR Rezina
//
//  Created by Stefan Popa on 06.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEDLazyImageView;

@interface TEDArticleModelObject : NSObject
{
    //--------------------------------------------------------------------------
      NSDictionary* theAttributes;
    //--------------------------------------------------------------------------
      NSURL *articleImageURL;
      NSURL *articleURL;
      TEDLazyImageView *imageView;    
    //--------------------------------------------------------------------------
}
//------------------------------------------------------------------------------
@property (nonatomic, strong) NSDictionary* theAttributes;
@property (nonatomic, strong) NSURL *articleImageURL;
@property (nonatomic, strong) NSURL *articleURL;
@property (nonatomic, strong) TEDLazyImageView *imageView;
//------------------------------------------------------------------------------

- (id) initWithAttributes: (NSDictionary*) attributes;
- (NSString *) objectForKey: (id) key;

@end
