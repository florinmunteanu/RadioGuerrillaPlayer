
#import <Foundation/Foundation.h>

@interface RadioUserSettings : NSObject

@property (nonatomic) BOOL autoPlay;

+ (instancetype)sharedInstance;

- (BOOL)synchronize;

@end
