//
//  Artist.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 23/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavoriteSong;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * smallImage;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addSongsObject:(FavoriteSong *)value;
- (void)removeSongsObject:(FavoriteSong *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
