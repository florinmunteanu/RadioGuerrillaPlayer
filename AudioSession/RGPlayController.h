
#import <Foundation/Foundation.h>

@interface RGPlayController : NSObject

@property (nonatomic) BOOL playing;

@property (strong, nonatomic, readonly) NSString* currentSong;

@property (strong, nonatomic, readonly) NSString* currentArtist;

@property (strong, nonatomic) NSString* streamTitle;

- (BOOL)isStreamTitleASong;

@end
