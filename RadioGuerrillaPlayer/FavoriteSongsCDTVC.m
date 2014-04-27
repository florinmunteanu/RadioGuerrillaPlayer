
#import "FavoriteSongsCDTVC.h"
#import "RGAppDelegate.h"
#import "FavoriteSong+Guerrilla.h"
#import "FavoriteSong.h"
#import "PlayerViewController.h"
#import "Artist.h"
#import "FavoriteSongTableViewCell.h"

@interface FavoriteSongsCDTVC ()

@end

@implementation FavoriteSongsCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteSongTableViewCell* cell = (FavoriteSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FavoriteSongCell"];
    
    FavoriteSong* song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = song.song;
    cell.detailTextLabel.text = song.artist;
    
    if (song.artistInfo.smallImage == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"empty_star"];
    }
    else
    {
        cell.imageView.image = [UIImage imageWithData:song.artistInfo.smallImage];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSError* error = nil;
        FavoriteSong* f = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [FavoriteSong deleteSongFromFavorites:f.song
                                   fromArtist:f.artist
                       inManagedObjectContext:self.managedObjectContext
                                        error:&error];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
