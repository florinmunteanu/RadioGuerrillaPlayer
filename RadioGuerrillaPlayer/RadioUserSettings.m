//
//  RadioUserSettings.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 17/04/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "RadioUserSettings.h"

@implementation RadioUserSettings

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setAutoPlay:(BOOL)autoPlay
{
    NSNumber* isOn =[NSNumber numberWithBool:autoPlay];
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:@"AUTO_START"];
}

- (BOOL)autoPlay
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"AUTO_START"];
}

- (BOOL)synchronize
{
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
