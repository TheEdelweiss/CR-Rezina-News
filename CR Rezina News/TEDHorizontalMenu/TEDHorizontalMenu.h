//
//  TEDHorizontalMenu.h
//  HorizontalMenu
//
//  Created by Stefan Popa on 28.12.12.
//  Copyright (c) 2012 Popa Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TEDHorizontalMenuDelegate.h"


@interface TEDHorizontalMenu : UIScrollView {
    
    id <TEDHorizontalMenuDelegate> __unsafe_unretained itemSelectedDelegate;
    NSMutableData *receivedData;
    NSURLConnection *collectionConnection;
    
}

 @property (nonatomic, strong) NSMutableData *receivedData;
 @property (nonatomic, strong) NSURLConnection *collectionConnection;
 @property (nonatomic, strong) NSDictionary *items;
 @property (nonatomic, strong) NSMutableArray *categoryIDs;
 @property (nonatomic, unsafe_unretained) id <TEDHorizontalMenuDelegate> itemSelectedDelegate;
 @property int itemCount;

-(void) setSelectedElementAtIndex: (int) index
                         animated: (BOOL) animated;

-(void) startWithURL:(NSURL *) URL
      andPOSTParams: (NSString *) params;

@end

