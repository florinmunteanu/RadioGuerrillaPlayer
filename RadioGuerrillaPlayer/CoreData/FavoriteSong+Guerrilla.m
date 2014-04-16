
#import "FavoriteSong+Guerrilla.h"
#import "Artist+Guerrilla.h"
#import "Artist.h"
#import "FavoriteSongResult.h"

@implementation FavoriteSong (Guerrilla)

/* Get or add a favorite the song. 
 * If the song already exists, it will return the existing instance, otherwise it will add a new favorite song.
 */
+ (FavoriteSongResult *)getOrAddSong:(NSString *)song
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
    FavoriteSongState state = FavoriteSongNoState;
    
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
        
        state = FavoriteSongSavedSuccessfully;
    }
    else
    {
        favoriteSong = [matches lastObject];
        state = FavoriteSongAlreadyAdded;
    }
    return [[FavoriteSongResult alloc] initWithFavoriteSong:favoriteSong andState:state];
}

+ (NSFetchRequest *)createSongFetchRequest:(NSString *)song artist:(NSString *)artist
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    request.predicate = [NSPredicate predicateWithFormat:@"(artist = %@) AND (song = %@)", artist, song];
    
    return request;
}

+ (NSFetchRequest *)createAllSongsFetchRequest
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"savedDate" ascending:NO]];
    request.predicate = nil; // get all favorite songs
    
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

+ (FavoriteSongResult *)getOrAddSong:(NSString *)song
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
    
    FavoriteSongResult* favoriteSongResult = [FavoriteSong getOrAddSong:song
                                                             fromArtist:artist
                                                 inManagedObjectContext:context
                                                                  error:&currentError];
    if (currentError)
    {
        *error = currentError;
        return nil;
    }
    return favoriteSongResult;
}

+ (void)deleteAllSongs:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSError* fetchError = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteSong"];
    request.predicate = nil;
    
    NSArray* matches = [context executeFetchRequest:request error:&fetchError];
    
    if (fetchError)
    {
        *error = fetchError;
    }
    else if (matches.count > 0)
    {
        for (NSManagedObject* song in matches)
        {
            [context deleteObject:song];
        }
    }
}

@end
