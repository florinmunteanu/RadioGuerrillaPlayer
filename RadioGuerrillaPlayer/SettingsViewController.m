
#import "SettingsViewController.h"
#import "FavoriteSong+Guerrilla.h"
#import "Artist+Guerrilla.h"
#import "PlayerViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delaysContentTouches = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting" forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self setAutoPlayCell:cell];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        [self setDeleteDataCell:cell];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self setIcon8Cell:cell];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        [self setLastFmCell:cell];
    }
    
    [self delayContentTouches:cell];
    
    return cell;
}

- (void)delayContentTouches:(UITableViewCell *)cell
{
    //http://stackoverflow.com/questions/19256996/uibutton-not-showing-highlight-on-tap-in-ios7
    
    // https://developer.apple.com/library/ios/documentation/uikit/reference/uiscrollview_class/Reference/UIScrollView.html#//apple_ref/occ/instp/UIScrollView/delaysContentTouches
    // delaysContentTouches
    // A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
}

- (void)setLastFmCell:(UITableViewCell *) cell
{
    cell.textLabel.text = @"Images by Last.fm";
    
    UIButton* lastFmLink = [UIButton buttonWithType:UIButtonTypeSystem];
    lastFmLink.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
    [lastFmLink setTitle:@"Link" forState:UIControlStateNormal];
    [lastFmLink addTarget:self
                   action:@selector(openLinkToLastfm)
         forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = lastFmLink;
}

- (void)setIcon8Cell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"Icons by icon8";
    
    UIButton* icon8Link = [UIButton buttonWithType:UIButtonTypeSystem];
    icon8Link.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
    [icon8Link setTitle:@"Link"
               forState:UIControlStateNormal];
    [icon8Link addTarget:self
                  action:@selector(openLinkToIcon8)
        forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = icon8Link;
}

- (void)setDeleteDataCell:(UITableViewCell *)cell
{
    UIButton* deleteAllSongsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteAllSongsButton.frame = cell.bounds;
    deleteAllSongsButton.backgroundColor = [UIColor redColor];
    
    [deleteAllSongsButton setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
    [deleteAllSongsButton setTitle:@"Delete all data"
                          forState:UIControlStateNormal];
    [deleteAllSongsButton addTarget:self
                             action:@selector(deleteAllData)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:deleteAllSongsButton];
}

- (void)setAutoPlayCell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"Auto play when app starts";
    
    UISwitch* autoPlaysSwitch = [[UISwitch alloc] init];
    autoPlaysSwitch.frame = CGRectMake(0.0f, 0.0f, 150, 25.0f);
    
    cell.accessoryView = autoPlaysSwitch;
}

- (void)openLinkToIcon8
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://icons8.com"]];
}

- (void)openLinkToLastfm
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.lastfm.com"]];
}

- (void)deleteAllData
{
    [FavoriteSong deleteAllSongs:self.managedObjectContext error:nil];
    [Artist deleteAllArtists:self.managedObjectContext error:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Application";
    }
    else if (section == 1)
    {
        return @"Thanks";
    }
    return @"";
}

@end
