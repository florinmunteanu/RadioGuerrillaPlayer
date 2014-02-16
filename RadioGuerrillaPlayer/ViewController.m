//
//  ViewController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 09/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "ViewController.h"
#import "RGPlayController.h"
#import "RGAudioSessionManager.h"
#import "LastfmClient.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.playController addObserver:self forKeyPath:@"currentSong" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playController addObserver:self forKeyPath:@"currentArtist" options:NSKeyValueObservingOptionNew context:NULL];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.playController removeObserver:self forKeyPath:@"currentSong"];
    [self.playController removeObserver:self forKeyPath:@"currentArtist"];
    
    [super viewWillDisappear:animated];
}

- (IBAction)getArtistInfo:(id)sender
{
    LastfmClient* lastfmClient = [[LastfmClient alloc] initWithApiKey:@""];
    
    [lastfmClient sendGetArtistInfo:self.playController.currentArtist
            withCompletationHandler:^(ArtistInfoResponse* response) {
                if (response && response.artistInfo)
                {
                    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:response.artistInfo.mediumImageURL]];
                    self.artistImage.image = nil;
                    self.artistImage.image = [[UIImage alloc] initWithData:imageData];
                }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.playController)
    {
        if ([keyPath isEqualToString:@"currentSong"])
        {
            self.songLabel.text = self.playController.currentSong;
        }
        else if ([keyPath isEqualToString:@"currentArtist"])
        {
            self.artistLabel.text = self.playController.currentArtist;
        }
    }
}

@end
