//
//  ViewController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 09/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "ViewController.h"
//#import <MediaPlayer/MediaPlayer.h>
#import "RGPlayController.h"
#import "RGAudioSessionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

//@property (strong, nonatomic) AVPlayer* songPlayer;

//@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@property (strong, nonatomic) RGPlayController* playController;

@property (strong, nonatomic) RGAudioSessionManager* audioSessionManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.playController = [[RGPlayController alloc] init];
    self.audioSessionManager = [[RGAudioSessionManager alloc] initWithPlayController:self.playController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePlayState:(id)sender
{
    if (self.playController.playing == YES)
    {
        self.playController.playing = NO;
        [self setPlayTitle:@"Play"];
    }
    else
    {
        self.playController.playing = YES;
        [self setPlayTitle:@"Stop"];
    }
}

- (void)setPlayTitle:(NSString *)title
{
    [self.playActionButton setTitle:title forState:UIControlStateNormal];
    [self.playActionButton setTitle:title forState:UIControlStateSelected];
    [self.playActionButton setTitle:title forState:UIControlStateHighlighted];
}

/*
-(void)playselectedsong
{
    //https://developer.apple.com/library/ios/qa/qa1668/_index.html
    
    NSError* errors = nil;
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    //setCategory:AVAudioSessionCategoryPlayback
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&errors];
    if (errors)
    {
        NSLog(@"%@", errors);
        return;
    }
    [audioSession setActive:YES error:&errors];
    if (errors)
    {
        NSLog(@"%@", errors);
        return;
    }
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Warning: Still playing music, but background task expired.");
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@"http://live.eliberadio.ro:8002"]];
    self.songPlayer = player;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.songPlayer currentItem]];
    [self.songPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    
    
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
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //  code here to play next sound file
    
}
*/
@end
