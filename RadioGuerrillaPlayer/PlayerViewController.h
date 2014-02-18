//
//  ViewController.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 09/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* playActionButton;

@property (weak, nonatomic) IBOutlet UILabel* songLabel;

@property (weak, nonatomic) IBOutlet UILabel* artistLabel;

@property (weak, nonatomic) IBOutlet UIImageView* artistImage;

@property (weak, nonatomic) IBOutlet UIImageView *isFavoriteImage;

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
