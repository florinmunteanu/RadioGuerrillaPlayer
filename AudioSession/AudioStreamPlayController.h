
#import <Foundation/Foundation.h>

@interface AudioStreamPlayController : NSObject

@property (nonatomic) BOOL playing;

@property (strong, nonatomic, readonly) NSString* currentSong;

@property (strong, nonatomic, readonly) NSString* currentArtist;

@property (strong, nonatomic) NSString* streamTitle;

- (BOOL)isStreamTitleASong;

+ (instancetype)sharedInstance;

@end
