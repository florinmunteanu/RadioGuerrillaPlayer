//
//  RGAudioSessionManager.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 11/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "RGAudioSessionManager.h"
#import "RGPlayController.h"
#import <AVFoundation/AVFoundation.h>

@interface RGAudioSessionManager()

@property (strong, nonatomic) RGPlayController* playController;

@property (nonatomic) BOOL audioSessionIsConfiguredForPlayback;

@property (strong, nonatomic) AVPlayer* songPlayer;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation RGAudioSessionManager

typedef enum { NoExtraKnowledge, WillPlay } AudioSessionStateMatchingOptions;

- (id)initWithPlayController:(RGPlayController *)playController
{
    self = [super init];
    
    self.playController = playController;
    
    [self.playController addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:NULL];
    return self;
}

- (void)dealloc
{
    [self.playController removeObserver:self forKeyPath:@"playing"];
}

/*
- (void)playingChanged:(NSDictionary *)change
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
 */

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
        [self.songPlayer pause];
    }
}

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
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Warning: Still playing music, but background task expired.");
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    NSString* liveStreamUrl = @"http://live.eliberadio.ro:8002";
    AVPlayer* player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:liveStreamUrl]];
    self.songPlayer = player;
    //[[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(playerItemDidReachEnd:)
    //                                             name:AVPlayerItemDidPlayToEndTimeNotification
    //                                           object:[self.songPlayer currentItem]];
    [self.songPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
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
    else if (object == self.playController && [keyPath isEqualToString:@"playing"])
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
}

@end
