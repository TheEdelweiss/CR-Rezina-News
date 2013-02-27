//
//  TEDContactsModel.m
//  CR Rezina
//
//  Created by Stefan Popa on 19.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import "TEDContactsModel.h"

@implementation TEDContactsModel
//------------------------------------------------------------------------------
@synthesize theAttributes;
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
