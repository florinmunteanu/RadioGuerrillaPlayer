//
//  RGPlayController.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 11/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGPlayController : NSObject

@property (nonatomic) BOOL playing;

@property (strong, nonatomic, readonly) NSString* currentSong;

@property (strong, nonatomic, readonly) NSString* currentArtist;

@property (strong, nonatomic) NSString* streamTitle;

- (BOOL)isStreamTitleASong;

@end
