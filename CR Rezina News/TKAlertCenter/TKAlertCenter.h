//
//  TKAlertCenter.h
//  Created by Devin Ross on 9/29/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TKAlertView;

/** A notification center for displaying quick bursts of alert information to the user. */
@interface TKAlertCenter : NSObject {
	NSMutableArray *_alerts;
	BOOL _active;
	TKAlertView *_alertView;
	CGRect _alertFrame;
}

/** Returns the process’s default notification center. 
 @return The current process’s default notification center, which is used for alert notifications.
 */
+ (TKAlertCenter*) defaultCenter;


/** Posts a given alert message to the user.
 @param message The message shown under an image.
 @param image The image displayed to the user. If image is nil, the message will only be shown.
 */
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image;

/** Posts a given alert message to the user.
 @param message The message shown under an image.
 */
- (void) postAlertWithMessage:(NSString *)message;

@end