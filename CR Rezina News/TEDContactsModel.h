//
//  TEDContactsModel.h
//  CR Rezina
//
//  Created by Stefan Popa on 19.02.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDContactsModel : NSObject
{
    //--------------------------------------------------------------------------
    NSDictionary* theAttributes;
    //--------------------------------------------------------------------------
}

//------------------------------------------------------------------------------
@property (nonatomic, strong) NSDictionary* theAttributes;
//------------------------------------------------------------------------------

- (id) initWithAttributes: (NSDictionary*) attributes;
- (NSString *) objectForKey: (id) key;

@end
