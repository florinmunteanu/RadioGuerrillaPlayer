//
//  ViewController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 09/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "PlayerViewController.h"
#import "RGPlayController.h"
#import "RGAudioSessionManager.h"
#import "LastfmClient.h"
#import "FavoriteSong+Guerrilla.h"
#import "FavoriteSong.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController ()

@property (strong, nonatomic) RGPlayController* playController;

@property (strong, nonatomic) RGAudioSessionManager* audioSessionManager;

@end

@implementation PlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.playController = [[RGPlayController alloc] init];
    self.audioSessionManager = [[RGAudioSessionManager alloc] initWithPlayController:self.playController];
    
    if ([self.artistLabel.text isEqualToString:@"Artist"])
    {
        self.artistLabel.text = @"";
    }
    if ([self.songLabel.text isEqualToString:@"Song"])
    {
        self.songLabel.text = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.playController addObserver:self forKeyPath:@"streamTitle" options:NSKeyValueObservingOptionNew context:NULL];
    
    if (self.managedObjectContext == nil)
    {
        [self initManagedDocument];
    }
}

/* Creates the NSManagedObjectContext required by Core Data. 
 */
- (void)initManagedDocument
{
    NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"RadioDocument"];
    
    UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]] == NO)
    {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
             if (success == YES)
             {
                 self.managedObjectContext = document.managedObjectContext;
             }
          }];
    }
    else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success == YES)
            {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }
    else
    {
        self.managedObjectContext = document.managedObjectContext;
    }
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

- (void)viewWillDisappear:(BOOL)animated
{
    [self.playController removeObserver:self forKeyPath:@"streamTitle"];

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
        if ([keyPath isEqualToString:@"streamTitle"])
        {
            self.artistLabel.text = self.playController.currentArtist;
            self.songLabel.text = self.playController.currentSong;
            
            BOOL isInFavorites = [FavoriteSong songIsInFavorites:self.playController.currentSong
                                                      fromArtist:self.playController.currentArtist
                                          inManagedObjectContext:self.managedObjectContext
                                                           error:nil];
            
            [self.isFavoriteButton setSelected:isInFavorites];
        }
    }
}

- (IBAction)isFavoriteChanged:(id)sender
{
    if (self.playController.isStreamTitleASong == TRUE)
    {
        self.isFavoriteButton.enabled = FALSE;
    
        NSError* error = nil;
        BOOL isSongInFavorites = [FavoriteSong songIsInFavorites:self.playController.currentSong
                                                      fromArtist:self.playController.currentArtist
                                          inManagedObjectContext:self.managedObjectContext
                                                           error:&error];
        if (isSongInFavorites)
        {
            [FavoriteSong deleteSongFromFavorites:self.playController.currentSong
                                       fromArtist:self.playController.currentArtist
                           inManagedObjectContext:self.managedObjectContext
                                            error:&error];
            
            [self.isFavoriteButton setSelected:FALSE];
        }
        else
        {
            [FavoriteSong getOrAddSong:self.playController.currentSong
                        fromArtistName:self.playController.currentArtist
                inManagedObjectContext:self.managedObjectContext
                                 error:&error];
            
            [self.isFavoriteButton setSelected:TRUE];
        }
    
        self.isFavoriteButton.enabled = TRUE;
    }
}

- (IBAction)addSong:(id)sender
{
    NSError* error = nil;
    [FavoriteSong getOrAddSong:@"Take a Chance" fromArtistName:@"ABBA" inManagedObjectContext:self.managedObjectContext error:&error];
    [FavoriteSong getOrAddSong:@"Bohemian Rhapsody" fromArtistName:@"Queen" inManagedObjectContext:self.managedObjectContext error:&error];
    [FavoriteSong getOrAddSong:@"Counting Stars" fromArtistName:@"One Republic" inManagedObjectContext:self.managedObjectContext error:&error];
    [FavoriteSong getOrAddSong:@"Stars" fromArtistName:@"Katy Perry" inManagedObjectContext:self.managedObjectContext error:&error];
    
    [self.managedObjectContext save:&error];
    
    NSFetchRequest* request = [FavoriteSong createAllSongsFetchRequest];
    /*self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
     managedObjectContext:self.managedObjectContext
     sectionNameKeyPath:nil
     cacheName:nil];
     */
    NSError* fetchRequestError = nil;
    NSArray* matches = [self.managedObjectContext executeFetchRequest:request error:&fetchRequestError];
}

@end
