//
//  FavoriteSong+Guerrilla.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSong.h"

@interface FavoriteSong (Guerrilla)

+ (NSFetchRequest *)createAllSongsFetchRequest;

+ (BOOL)songIsInFavorites:(NSString *)song
               fromArtist:(NSString *)artist
   inManagedObjectContext:(NSManagedObjectContext *)context
                    error:(NSError **)error;

+ (FavoriteSong *)getOrAddSong:(NSString *)song
                fromArtistName:(NSString *)artistName
        inManagedObjectContext:(NSManagedObjectContext *)context
                         error:(NSError **)error;

+ (BOOL)deleteSongFromFavorites:(NSString *)song
                     fromArtist:(NSString *)artist
         inManagedObjectContext:(NSManagedObjectContext *)context
                          error:(NSError **)error;

+ (void)deleteAllSongs:(NSManagedObjectContext *)context
                 error:(NSError **)error;

@end
