//
//  FavoriteSongsCDTVC.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 17/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSongsCDTVC.h"
#import "AppDelegate.h"

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

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];

    dispatch_async(kBgQueue, ^{
       
    });
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    if (managedObjectContext)
    {
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
