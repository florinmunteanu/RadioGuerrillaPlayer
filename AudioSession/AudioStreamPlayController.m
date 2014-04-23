
#import "AudioStreamPlayController.h"
#import "AudioStreamSessionManager.h"

@interface AudioStreamPlayController()

@property (strong, nonatomic) NSString* currentSong;

@property (strong, nonatomic) NSString* currentArtist;

@end

@implementation AudioStreamPlayController

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    static AudioStreamSessionManager* audioSession;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        audioSession = [[AudioStreamSessionManager alloc] initWithPlayController:sharedInstance];
    });
    return sharedInstance;
}

- (void)setStreamTitle:(NSString *)streamTitle
{
    _streamTitle = streamTitle;
    
    NSArray* components = [self.streamTitle componentsSeparatedByString:@"-"];
    if (components.count > 0)
    {
        self.currentArtist =  (NSString *)[components objectAtIndex:0];
        self.currentArtist = [self.currentArtist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (components.count > 1)
        {
            self.currentSong = (NSString *)[components objectAtIndex:1];
            self.currentSong = [self.currentSong stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else
        {
            self.currentSong = @"";
        }
    }
    else
    {
        self.currentArtist = @"";
        self.currentSong = @"";
    }
}

- (BOOL)isStreamTitleASong
{
    if (self.streamTitle == nil || [self.streamTitle isEqualToString:@""])
    {
        return NO;
    }
    
    NSString* lowerCaseStreamTitle = [self.streamTitle lowercaseString];
    return [lowerCaseStreamTitle rangeOfString:@"guerrilla"].length == 0;
}

@end
