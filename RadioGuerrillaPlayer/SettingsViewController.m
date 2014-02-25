//
//  SettingsViewController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 24/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cell.textLabel.text = @"Auto play when app starts";
        
        UISwitch* autoPlaysSwitch = [[UISwitch alloc] init];
        autoPlaysSwitch.frame = CGRectMake(0.0f, 0.0f, 150, 25.0f);
    
        cell.accessoryView = autoPlaysSwitch;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
       cell.textLabel.text = @"Delete all favorite songs";
        
        UIButton* deleteAllSongsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteAllSongsButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
        deleteAllSongsButton.backgroundColor = [UIColor redColor];
        
        [deleteAllSongsButton setTitleColor:[UIColor whiteColor]
                                   forState:UIControlStateNormal];
        [deleteAllSongsButton setTitle:@"Delete"
                              forState:UIControlStateNormal];
        
        cell.accessoryView = deleteAllSongsButton;
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
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
    else if (indexPath.section == 1 && indexPath.row == 1)
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
    
    return cell;
}

- (void)openLinkToIcon8
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://icons8.com"]];
}

- (void)openLinkToLastfm
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.lastfm.com"]];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
