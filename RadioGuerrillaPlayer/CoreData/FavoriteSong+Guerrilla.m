//
//  FavoriteSong+Guerrilla.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSong+Guerrilla.h"
#import "Artist.h"

@implementation FavoriteSong (Guerrilla)

+ (FavoriteSong *)fromArtist:(Artist *)artist
                        song:(NSString *)song
      inManagedObjectContext:(NSManagedObjectContext *)context
                       error:(NSError **)error
{
    if (artist == nil)
    {
        return nil;
    }
    if (song == nil || [song isEqualToString:@""])
    {
        return nil;
    }
    NSError* favoriteSongError = nil;
    FavoriteSong* favoriteSong = nil;
    
    NSFetchRequest* artistRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    artistRequest.predicate = [NSPredicate predicateWithFormat:@"(artist = %@) AND (song = %@)", artist.name, song];
    
    NSArray* matches = [context executeFetchRequest:artistRequest error:&favoriteSongError];
    
    if (favoriteSongError)
    {
        *error = favoriteSongError;
    }
    else if (matches.count == 0)
    {
        favoriteSong = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteSong" inManagedObjectContext:context];
        favoriteSong.artist = artist.name;
        favoriteSong.song = song;
        favoriteSong.artistInfo = artist;
    }
    else
    {
        favoriteSong = [matches lastObject];
    }
    return favoriteSong;
}

@end
