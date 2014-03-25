//
//  RadioStationsPopUpViewController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 21/03/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "RadioStationsPopUpViewController.h"
#import "HorizontalScroller.h"
#import "HorizontalScrollerDelegate.h"

@interface RadioStationsPopUpViewController () <HorizontalScrollerDelegate>
{
    __weak IBOutlet HorizontalScroller *scroller;
}

@end

@implementation RadioStationsPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    scroller.delegate = self;
    
    [self.popupView addSubview:scroller];
    
    [scroller reload];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showAnimation
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimation
{
    [UIView animateWithDuration: .25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.view removeFromSuperview];
        }
    }];
}

- (IBAction)closePopup:(id)sender
{
    [self removeAnimation];
}

- (void)showInView:(UIView *)parentView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [parentView addSubview:self.view];
        if (animated)
        {
            [self showAnimation];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Radio stations horizontal scroller

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index
{
    [self removeAnimation];
}

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index
{
    UIImageView* imageView;
    if (index == 0)
    {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio-guerrilla-logo"]];
    }
    else if (index == 1)
    {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magic-fm-logo.jpg"]];
    }
    else if (index == 2)
    {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rock-fm-logo.jpg"]];
    }
    else if (index == 3)
    {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"romantic-fm-logo.png"]];
    }
    return imageView;
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller
{
    return 4;
}

@end
