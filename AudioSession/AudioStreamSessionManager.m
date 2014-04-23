
#import "AudioStreamSessionManager.h"
#import "AudioStreamPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>

@interface AudioStreamSessionManager()

@property (strong, nonatomic) AudioStreamPlayController* playController;

@property (nonatomic) BOOL audioSessionIsConfiguredForPlayback;

@property (strong, nonatomic) AVPlayer* songPlayer;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation AudioStreamSessionManager

NSString* const playingKeyPath = @"playing";
NSString* const statusKeyPath = @"status";
NSString* const metadataKeyPath = @"timedMetadata";

typedef enum { NoExtraKnowledge, WillPlay } AudioSessionStateMatchingOptions;

- (instancetype)initWithPlayController:(AudioStreamPlayController *)playController
{
    self = [super init];
    
    if (self != nil)
    {
        self.playController = playController;
    
        [self.playController addObserver:self forKeyPath:playingKeyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self.playController removeObserver:self forKeyPath:playingKeyPath];
    [self.songPlayer removeObserver:self forKeyPath:statusKeyPath];
    [[self.songPlayer currentItem] removeObserver:self forKeyPath:metadataKeyPath];
}

- (void)matchAudioSessionWithPlayState:(AudioSessionStateMatchingOptions)options
{
    //https://developer.apple.com/library/ios/qa/qa1668/_index.html
    //http://overooped.com/post/46426447128/continuously-playing-music-in-the-background-on-ios
    
    AVAudioSession* sharedAudioSession = [AVAudioSession sharedInstance];
    BOOL isPlaying = self.playController.playing || (options == WillPlay);
    
    if (isPlaying == YES && self.audioSessionIsConfiguredForPlayback == NO)
    {
        // Going from a paused state to a playing state
        
        self.audioSessionIsConfiguredForPlayback = YES;
        [self startAudioSession:sharedAudioSession];
    }
    else if (isPlaying == NO && self.audioSessionIsConfiguredForPlayback)
    {
         // Going from a playing state to a paused state
        
        self.audioSessionIsConfiguredForPlayback = NO;
        [self stopAudioSession:sharedAudioSession];
    }
}

#pragma mark - Start / Stop audio session

- (void)startAudioSession:(AVAudioSession *)audioSession
{
    NSError* errors = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&errors];
    if (errors)
    {
        NSLog(@"An error occurred while setting category to playback on audio session: %@", errors);
        return;
    }
    [audioSession setActive:YES error:&errors];
    if (errors)
    {
        NSLog(@"An error occurred while setting the audio session as active: l%@", errors);
        return;
    }
    
    [self createBackgroundTask];
    [self createPlayer];
    [self addObservers];
}

- (void)stopAudioSession:(AVAudioSession *)audioSession
{
    NSError* errors = nil;
    
    [audioSession setActive:NO error:&errors];
    
    if (errors)
    {
        NSLog(@"An error occurred while setting the audio session as inactive: %@", errors);
    }
    if (self.backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
    
    [self destroyPlayer];
}

- (void)createBackgroundTask
{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Warning: Still playing music, but background task expired.");
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
}

- (void)createPlayer
{
    NSString* liveStreamUrl = @"http://live.eliberadio.ro:8002";
    self.songPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:liveStreamUrl]];
}

- (void)destroyPlayer
{
    [self.songPlayer pause];
    self.songPlayer = nil;
}

#pragma mark - Metadata Observer

- (void)addObservers
{
    [self.songPlayer addObserver:self forKeyPath:statusKeyPath options:0 context:nil];
    
    [[self.songPlayer currentItem] addObserver:self forKeyPath:metadataKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.songPlayer && [keyPath isEqualToString:@"status"])
    {
        if (self.songPlayer.status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayer Failed");
        }
        else if (self.songPlayer.status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.songPlayer play];
            
        }
        else if (self.songPlayer.status == AVPlayerItemStatusUnknown)
        {
            NSLog(@"AVPlayer Unknown");
        }
    }
    else if (object == self.playController && [keyPath isEqualToString:playingKeyPath])
    {
        BOOL isPrior = [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
        
        if (isPrior && self.playController.playing == NO)
        {
            [self matchAudioSessionWithPlayState:WillPlay];
        }
        else if (isPrior == NO)
        {
            [self matchAudioSessionWithPlayState:NoExtraKnowledge];
        }

    }
    else if (object == [self.songPlayer currentItem] && [keyPath isEqualToString:metadataKeyPath])
    {
        [self readMetadata:(AVPlayerItem *)object];
    }
}

- (void)readMetadata:(AVPlayerItem *)playerItem
{
    for (AVMetadataItem* metadata in playerItem.timedMetadata)
    {
        if ([metadata.commonKey isEqualToString:@"title"])
        {
            self.playController.streamTitle = metadata.stringValue;
        }
    }
}

@end
