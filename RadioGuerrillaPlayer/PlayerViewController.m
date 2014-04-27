
#import "PlayerViewController.h"
#import "AudioStreamPlayController.h"
#import "AudioStreamSessionManager.h"
#import "LastfmClient.h"
#import "FavoriteSong+Guerrilla.h"
#import "FavoriteSong.h"
#import "Artist.h"
#import "Artist+Guerrilla.h"
#import "RGAppDelegate.h"
#import "ArtistInfoResponse.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayButton.h"
#import "FavoriteSongResult.h"
#import "RadioUserSettings.h"
#import <TSMessages/TSMessage.h>

extern NSString* RGRemoteControlPlayButtonTapped;
extern NSString* RGRemoteControlPauseButtonTapped;
extern NSString* RGRemoteControlStopButtonTapped;

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UILabel* songLabel;

@property (weak, nonatomic) IBOutlet UILabel* artistLabel;

@property (weak, nonatomic) IBOutlet UIButton* isFavoriteButton;

@property (strong, nonatomic) UIImageView* imageViewBackground;

@property (weak, nonatomic) IBOutlet PlayButton *playButton;

@property (strong, nonatomic) NSString* lastfmApiKey;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //http://thedesigninspiration.com/patterns/sprinkles/
    self.imageViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme.jpg"]];
    self.imageViewBackground.frame = self.view.bounds;
    [[self view] addSubview:self.imageViewBackground];

    [self.imageViewBackground.superview sendSubviewToBack:self.imageViewBackground];
    
    if ([self.artistLabel.text isEqualToString:@"Artist"])
    {
        self.artistLabel.text = @"";
    }
    if ([self.songLabel.text isEqualToString:@"Song"])
    {
        self.songLabel.text = @"";
    }
    
    /* Read the lastfm api key from api_keys.plist.
       This file is included in gitignore file, so it's not available on github.
     */
    [self readLastfmApiKey];
    
    /* Add observer for when the application is activated so we can play music if "auto start" setting is on.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOnApplicationActivated) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    /* Add observers to Remote control events in iOS. 
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlEventReceived:) name:RGRemoteControlPlayButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlEventReceived:) name:RGRemoteControlPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControlEventReceived:) name:RGRemoteControlStopButtonTapped object:nil];
    
    /* Add observer for interruptions that cause the audio session to stop (e.g. phone call). 
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void) onAudioSessionEvent: (NSNotification *) notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification])
    {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            [self pausePlay];
        }
        else
        {
            [self resumePlay];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[AudioStreamPlayController sharedInstance] removeObserver:self forKeyPath:@"streamTitle"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RGRemoteControlPlayButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RGRemoteControlPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RGRemoteControlStopButtonTapped object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Because on viewWillDisappear we remove the observer, the current song/artist could have changed.
    // We must make sure the UI is updated with the current song/artist.
    [self updateUIOnStreamTitleChanged];
    
    [[AudioStreamPlayController sharedInstance] addObserver:self forKeyPath:@"streamTitle" options:NSKeyValueObservingOptionNew context:NULL];
    
    if ([AudioStreamPlayController sharedInstance].isStreamTitleASong == NO)
    {
        self.isFavoriteButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)changePlayState:(id)sender
{
    [self changePlayState];
}

- (void)playOnApplicationActivated
{
    if ([AudioStreamPlayController sharedInstance].playing == NO && [RadioUserSettings sharedInstance].autoPlay)
    {
        [self resumePlay];
    }
}

- (void)remoteControlEventReceived:(NSNotification *)notification
{
    if ([notification.name isEqualToString:RGRemoteControlPlayButtonTapped])
    {
        [self resumePlay];
    }
    else if ([notification.name isEqualToString:RGRemoteControlPauseButtonTapped] ||
             [notification.name isEqualToString:RGRemoteControlStopButtonTapped])
    {
        [self pausePlay];
    }
}

- (void)changePlayState
{
    if ([AudioStreamPlayController sharedInstance].playing)
    {
        [self pausePlay];
    }
    else
    {
        [self resumePlay];
    }
}

- (void)resumePlay
{
    [AudioStreamPlayController sharedInstance].playing = YES;
    self.playButton.selected = YES;
}

- (void)pausePlay
{
    [AudioStreamPlayController sharedInstance].playing = NO;
    self.playButton.selected = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AudioStreamPlayController sharedInstance] removeObserver:self forKeyPath:@"streamTitle"];

    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [AudioStreamPlayController sharedInstance])
    {
        if ([keyPath isEqualToString:@"streamTitle"])
        {
            [self updateUIOnStreamTitleChanged];
        }
    }
}

- (void)updateUIOnStreamTitleChanged
{
    if ([AudioStreamPlayController sharedInstance].isStreamTitleASong == YES)
    {
        self.artistLabel.text = [AudioStreamPlayController sharedInstance].currentArtist;
        self.songLabel.text = [AudioStreamPlayController sharedInstance].currentSong;
        
        BOOL isInFavorites = [FavoriteSong songIsInFavorites:[AudioStreamPlayController sharedInstance].currentSong
                                                  fromArtist:[AudioStreamPlayController sharedInstance].currentArtist
                                      inManagedObjectContext:self.managedObjectContext
                                                       error:nil];
        if (self.isFavoriteButton.hidden)
        {
            [self.isFavoriteButton setHidden:NO];
        }
    
        [self.isFavoriteButton setSelected:isInFavorites];
    }
}

- (IBAction)isFavoriteChanged:(id)sender
{
    if ([AudioStreamPlayController sharedInstance].isStreamTitleASong == YES)
    {
        self.isFavoriteButton.enabled = NO;
        
        /* Get a copy of current artist and song.
         * In case the current playing song/artist changes then our code won't be affected, we still have the original song/artist.
         */
        NSString* artistName = (NSString *)[[AudioStreamPlayController sharedInstance].currentArtist copy];
        NSString* songName = (NSString *)[[AudioStreamPlayController sharedInstance].currentSong copy];
        NSError*  error = nil;
        
        BOOL isSongInFavorites = [FavoriteSong songIsInFavorites:songName
                                                      fromArtist:artistName
                                          inManagedObjectContext:self.managedObjectContext
                                                           error:&error];
        if (isSongInFavorites)
        {
            [FavoriteSong deleteSongFromFavorites:songName
                                       fromArtist:artistName
                           inManagedObjectContext:self.managedObjectContext
                                            error:&error];
            
            [self.isFavoriteButton setSelected:NO];
        }
        else
        {
            FavoriteSongResult* result = [FavoriteSong getOrAddSong:songName
                                                     fromArtistName:artistName
                                             inManagedObjectContext:self.managedObjectContext
                                                              error:&error];
            if (error == nil && result.song != nil && result.song.artistInfo.smallImage == nil)
            {
                [self updateArtistImage:artistName];
            }
            if (result.resultState == FavoriteSongSavedSuccessfully)
            {
                [TSMessage showNotificationWithTitle:@"Favorite" subtitle:@"Song added to favorites." type:TSMessageNotificationTypeSuccess];
            }
            
            [self.isFavoriteButton setSelected:YES];
        }
    
        self.isFavoriteButton.enabled = YES;
    }
}

- (void)updateArtistImage:(NSString *)artistName
{
    if (artistName && artistName.length > 0)
    {
        LastfmClient* lastfmClient = [[LastfmClient alloc] initWithApiKey:self.lastfmApiKey];
        
        [lastfmClient sendGetArtistInfo:[AudioStreamPlayController sharedInstance].currentArtist
                  withCompletionHandler:^(ArtistInfoResponse* response) {
                      if (response && response.artistInfo)
                      {
                          dispatch_async(kBgQueue, ^(void) {
                              NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:response.artistInfo.mediumImageURL]];
                              
                              // Update the image on the main thread.
                              // It is the only thread valid to work with the managedObjectContext
                              dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                            [Artist updateImage:imageData
                                                                     artistName:response.artistName
                                                         inManagedObjectContext:self.managedObjectContext
                                                                          error:nil];
                                   });
                          });
                      }
                  }];

    }
}

- (void)readLastfmApiKey
{
    NSString* apiKeysFile = [[NSBundle mainBundle] pathForResource:@"api_keys" ofType:@"plist"];
    NSDictionary* fileContent = [[NSDictionary alloc] initWithContentsOfFile:apiKeysFile];
    
    self.lastfmApiKey = [(NSString *)[fileContent valueForKey:@"LastfmApiKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
