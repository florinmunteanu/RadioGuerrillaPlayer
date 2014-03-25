//
//  RadioStationsPopUpViewController.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 21/03/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioStationsPopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popupView;

- (void)showInView:(UIView *)parentView animated:(BOOL)animated;

@end
