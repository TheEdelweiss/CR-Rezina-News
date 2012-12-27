//
//  NAMenuItem.h
//
//  Created by Cameron Saul on 02/20/2012.
//  Copyright 2012 Cameron Saul. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NAMenuItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, assign) Class targetViewControllerClass;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image vcClass:(Class)targetClass;

@end
