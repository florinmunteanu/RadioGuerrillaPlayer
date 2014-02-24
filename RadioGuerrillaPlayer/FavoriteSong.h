//
//  FavoriteSong.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 23/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface FavoriteSong : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSDate * savedDate;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) Artist *artistInfo;

@end
