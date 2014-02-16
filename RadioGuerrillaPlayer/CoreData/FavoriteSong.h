//
//  FavoriteSong.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Artist.h"

@class Artist;

@interface FavoriteSong : Artist

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) Artist *artistInfo;

@end
