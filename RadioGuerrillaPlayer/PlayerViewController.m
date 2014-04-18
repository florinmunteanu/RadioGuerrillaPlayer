
#import "PlayerViewController.h"
#import "RGPlayController.h"
#import "RGAudioSessionManager.h"
#import "LastfmClient.h"
#import "FavoriteSong+Guerrilla.h"
#import "FavoriteSong.h"
#import "Artist.h"
#import "Artist+Guerrilla.h"
#import "AppDelegate.h"
#import "ArtistInfoResponse.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayButton.h"
#import "FavoriteSongResult.h"
#import "RadioUserSettings.h"
#import <TSMessages/TSMessage.h>

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UILabel* songLabel;

@property (weak, nonatomic) IBOutlet UILabel* artistLabel;

@property (weak, nonatomic) IBOutlet UIButton* isFavoriteButton;

@property (strong, nonatomic) RGPlayController* playController;

@property (strong, nonatomic) RGAudioSessionManager* audioSessionManager;

@property (strong, nonatomic) UIImageView* imageViewBackground;

@property (weak, nonatomic) IBOutlet PlayButton *playButton;

@property (strong, nonatomic) NSString* lastfmApiKey;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.playController = [[RGPlayController alloc] init];
    self.audioSessionManager = [[RGAudioSessionManager alloc] initWithPlayController:self.playController];
   
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
    
    [self readLastfmApiKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Because on viewWillDisappear we remove the observer, the current song/artist could have changed.
    // We must make sure the UI is updated with the current song/artist.
    [self updateUIOnStreamTitleChanged];
    
    [self.playController addObserver:self forKeyPath:@"streamTitle" options:NSKeyValueObservingOptionNew context:NULL];
    
    if (self.playController.isStreamTitleASong == NO)
    {
        self.isFavoriteButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startPlayingIfNecessary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePlayState:(id)sender
{
    [self changePlayState];
}

- (void)changePlayState
{
    if (self.playController.playing)
    {
        self.playController.playing = NO;
    }
    else
    {
        self.playController.playing = YES;
    }
    [self.playButton setSelected:self.playController.playing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.playController removeObserver:self forKeyPath:@"streamTitle"];

    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.playController)
    {
        if ([keyPath isEqualToString:@"streamTitle"])
        {
            [self updateUIOnStreamTitleChanged];
        }
    }
}

- (void)updateUIOnStreamTitleChanged
{
    if (self.playController.isStreamTitleASong == YES)
    {
        self.artistLabel.text = self.playController.currentArtist;
        self.songLabel.text = self.playController.currentSong;
        
        BOOL isInFavorites = [FavoriteSong songIsInFavorites:self.playController.currentSong
                                                  fromArtist:self.playController.currentArtist
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
    if (self.playController.isStreamTitleASong == YES)
    {
        self.isFavoriteButton.enabled = NO;
        
        /* Get a copy of current artist and song.
         * In case the current playing song/artist changes then our code won't be affected, we still have the original song/artist.
         */
        NSString* artistName = (NSString *)[self.playController.currentArtist copy];
        NSString* songName = (NSString *)[self.playController.currentSong copy];
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
        
        [lastfmClient sendGetArtistInfo:self.playController.currentArtist
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

- (void)startPlayingIfNecessary
{
    if ([RadioUserSettings sharedInstance].autoPlay && self.playController.playing == NO)
    {
        [self changePlayState];
    }
}

- (void)readLastfmApiKey
{
    NSString* apiKeysFile = [[NSBundle mainBundle] pathForResource:@"api_keys" ofType:@"plist"];
    NSDictionary* fileContent = [[NSDictionary alloc] initWithContentsOfFile:apiKeysFile];
    
    self.lastfmApiKey = [(NSString *)[fileContent valueForKey:@"LastfmApiKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
