//
//  RadioUserSettings.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 17/04/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioUserSettings : NSObject

@property (nonatomic) BOOL autoPlay;

+ (instancetype)sharedInstance;

- (BOOL)synchronize;

@end
