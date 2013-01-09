//
//  TEDHorizontalMenuModelObject.h
//  CR Rezina
//
//  Created by Stefan Popa on 31.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEDHorizontalMenuModelObject : NSObject

{
//-------------------------------------------------------------------------------------------------
    //horizontal menu items (category name with key > cat_name, and category ID with key > cat_id);
    NSDictionary* menuItems;
    
    //an array with category names (NSString*);
    NSArray* catsNamesArray;
//-------------------------------------------------------------------------------------------------
}

//----------------------------------------------------
@property (nonatomic, strong) NSDictionary* menuItems;
@property (nonatomic, strong) NSArray* catsNamesArray;
//----------------------------------------------------

//-------------------------------------------------------------
-(id) initWithNSDictionary: (NSDictionary*) categoryDictionary;
-(NSInteger) getThisCategoryID: (NSString*) categoryName;
-(NSInteger) getMeNumberOfItems;
//-------------------------------------------------------------

@end
