//
//  AppDelegate.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 09/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@property (strong, nonatomic) UIWindow *window;

@end
