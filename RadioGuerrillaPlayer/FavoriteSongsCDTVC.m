//
//  FavoriteSongsCDTVC.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 17/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSongsCDTVC.h"
#import "AppDelegate.h"
#import "FavoriteSong+Guerrilla.h"
#import "FavoriteSong.h"
#import "PlayerViewController.h"

@interface FavoriteSongsCDTVC ()

@end

@implementation FavoriteSongsCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.managedObjectContext == nil)
    {
        NSArray* vc = self.tabBarController.viewControllers;
        if ([vc[0] isKindOfClass:[PlayerViewController class]])
        {
            PlayerViewController* nc = (PlayerViewController *)vc[0];
            
            self.managedObjectContext = nc.managedObjectContext;
        }
    }
    [super viewWillAppear:animated];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        NSFetchRequest* request = [FavoriteSong createAllSongsFetchRequest];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
        //NSError* fetchRequestError = nil;
        //NSArray* matches = [managedObjectContext executeFetchRequest:request error:&fetchRequestError];
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteSong"];
    //NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[dateFormatter setDateFormat:@"dd-MM"];
    
    FavoriteSong* song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = song.song;
    cell.detailTextLabel.text = song.artist;
    
    //Word *word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = word.title;
    //cell.detailTextLabel.text = [dateFormatter stringFromDate:word.day];
    
    return cell;
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];

    dispatch_async(kBgQueue, ^{
       
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
