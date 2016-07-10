

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BasicViewController : UIViewController

- (void) showProgressWithInfoMessage:(NSString *)message;
- (void) showTemporaryInfoMessage:(NSString *)message;
- (void) updateProgressWithInfoMessage :(NSString *) message;
- (void) hideProgressAndMessage;



@end
