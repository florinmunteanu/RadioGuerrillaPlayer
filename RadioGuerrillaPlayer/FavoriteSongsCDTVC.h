//
//  FavoriteSongsCDTVC.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 17/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface FavoriteSongsCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;

@end
