//
//  NAMenuViewController.h
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//

#import "NAMenuView.h"

@interface NAMenuViewController : UIViewController<NAMenuViewDelegate>

@property (nonatomic, retain) NSArray *menuItems;

@end
