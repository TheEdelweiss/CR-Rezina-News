//
//  NSString+TEDHTMLEntities.h
//  CR Rezina
//
//  Created by Stefan Popa on 11.01.13.
//  Copyright (c) 2013 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TEDHTMLEntities)

- (NSString *)decodeHTMLEntities:(NSString *) string;

@end
