//
//  FavoriteSong+Guerrilla.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSong+Guerrilla.h"
#import "Artist+Guerrilla.h"
#import "Artist.h"

@implementation FavoriteSong (Guerrilla)

/* Get or add a favorite the song. 
 * If the song already exists, it will return the existing instance, otherwise it will add a new favorite song.
 */
+ (FavoriteSong *)getOrAddSong:(NSString *)song
                    fromArtist:(Artist *)artist
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
    
    NSFetchRequest* request = [FavoriteSong createSongFetchRequest:song artist:artist.name];
    NSArray* matches = [context executeFetchRequest:request error:&favoriteSongError];
    
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
        favoriteSong.savedDate = [NSDate date];
    }
    else
    {
        favoriteSong = [matches lastObject];
    }
    return favoriteSong;
}

+ (NSFetchRequest *)createSongFetchRequest:(NSString *)song artist:(NSString *)artist
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    request.predicate = [NSPredicate predicateWithFormat:@"(artist == %@) AND (song == %@)", artist, song];
    
    return request;
}

+ (NSFetchRequest *)createAllSongsFetchRequest
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"savedDate" ascending:NO]];
    request.predicate = nil; // get all favorite songs
    //request.predicate = [NSPredicate predicateWithFormat:@"artist = %@", @"Queen"]; //
    return request;
}

+ (BOOL)deleteSongFromFavorites:(NSString *)song
                     fromArtist:(NSString *)artist
         inManagedObjectContext:(NSManagedObjectContext *)context
                          error:(NSError **)error
{
    NSError* fetchRequestError = nil;
    NSFetchRequest* request = [FavoriteSong createSongFetchRequest:song artist:artist];
    NSArray* matches = [context executeFetchRequest:request error:&fetchRequestError];
    
    if (fetchRequestError)
    {
        *error = fetchRequestError;
        return FALSE;
    }
    else if (matches.count == 0)
    {
        return TRUE;
    }
    
    [context deleteObject:(FavoriteSong *)[matches lastObject]];
    return TRUE;
}

+ (BOOL)songIsInFavorites:(NSString *)song
               fromArtist:(NSString *)artist
   inManagedObjectContext:(NSManagedObjectContext *)context
                    error:(NSError **)error
{
    if (song == nil || [song isEqualToString:@""])
    {
        return FALSE;
    }
    if (artist == nil || [artist isEqualToString:@""])
    {
        return FALSE;
    }
    NSError* fetchError = nil;
    NSFetchRequest* request = [FavoriteSong createSongFetchRequest:song artist:artist];

    NSArray* matches = [context executeFetchRequest:request error:&fetchError];
    if (fetchError)
    {
        *error = fetchError;
        return FALSE;
    }
    return (matches.count > 0);
}

+ (FavoriteSong *)getOrAddSong:(NSString *)song
                fromArtistName:(NSString *)artistName
        inManagedObjectContext:(NSManagedObjectContext *)context
                         error:(NSError **)error
{
    if (artistName == nil || [artistName isEqualToString:@""])
    {
        return nil;
    }
    if (song == nil || [song isEqualToString:@""])
    {
        return nil;
    }
    
    NSError* currentError = nil;
    Artist* artist = [Artist getOrAddWithName:artistName smallImage:nil inManagedObjectContext:context error:&currentError];
    
    if (currentError)
    {
        *error = currentError;
        return nil;
    }
    
    FavoriteSong* favoriteSong = [FavoriteSong getOrAddSong:song
                                                 fromArtist:artist
                                     inManagedObjectContext:context
                                                      error:&currentError];
    if (currentError)
    {
        *error = currentError;
        return nil;
    }
    return favoriteSong;
}

+ (void)deleteAllSongs:(NSManagedObjectContext *)context error:(NSError **)error
{
    
}

@end
