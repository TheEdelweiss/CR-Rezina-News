//
//  TEDArticleModelObject.m
//  CR Rezina
//
//  Created by Stefan Popa on 06.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDArticleModelObject.h"

@implementation TEDArticleModelObject

//------------------------------------------------------------------------------
@synthesize articleImageURL,
            theAttributes,
            articleURL,
            imageView;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
- (id) initWithAttributes: (NSDictionary*)attributes
{
    if (self = [super init])
    {
        self.theAttributes = attributes;
    }
    
    return self;
}

//------------------------------------------------------------------------------

- (NSString *) objectForKey:(id)key
{
    return [self.theAttributes objectForKey:key];
}
@end
