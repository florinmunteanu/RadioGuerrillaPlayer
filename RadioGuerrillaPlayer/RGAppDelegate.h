
#import <UIKit/UIKit.h>

@interface RGAppDelegate : UIResponder <UIApplicationDelegate>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@property (strong, nonatomic) UIWindow *window;

@end
