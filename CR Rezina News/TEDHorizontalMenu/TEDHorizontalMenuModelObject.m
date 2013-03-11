//
//  TEDHorizontalMenuModelObject.m
//  CR Rezina
//
//  Created by Stefan Popa on 31.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import "TEDHorizontalMenuModelObject.h"

@implementation TEDHorizontalMenuModelObject

@synthesize menuItems,catsNamesArray;


-(id) initWithNSDictionary: (NSDictionary*) categoryDictionary
{
    
 if(self = [super init])
    {
        self.menuItems = categoryDictionary;
        
        NSString *strings[[self getMeNumberOfItems] + 1];
        strings[0] = @"Toate";
        int i = 1;
        
        for(NSDictionary *element in self.menuItems){
            strings[i] = [element valueForKey: @"cat_name"];
            i++;
         }
        
        self.catsNamesArray =
        [NSArray arrayWithObjects:strings count:[self getMeNumberOfItems]+1];
    }
    return self;
}


-(NSInteger) getThisCategoryID: (NSString*) categoryName
{
    NSNumber *catID;
    
    for(NSDictionary *element in self.menuItems)
    {
        if([categoryName isEqualToString: [element valueForKey:@"cat_name"]])
        {
            catID = [element valueForKey:@"cat_id"];
        }
    }
    
    return [catID integerValue];
}


//return the number of elements in dictionary
-(NSInteger) getMeNumberOfItems
{
   return [self.menuItems count];
}

@end
