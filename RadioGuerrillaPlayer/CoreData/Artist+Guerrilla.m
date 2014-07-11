
#import "Artist+Guerrilla.h"

@implementation Artist (Guerrilla)

+ (Artist *)getOrAddWithName:(NSString *)name
                  smallImage:(NSData *)smallImage
      inManagedObjectContext:(NSManagedObjectContext *)context
                       error:(NSError **)error
{
    if (name == nil || [name isEqualToString:@""])
    {
        return nil;
    }
    
    NSFetchRequest* artistRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    artistRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError* fetchError = nil;
    NSArray* matches = [context executeFetchRequest:artistRequest error:&fetchError];
    
    Artist* artist = nil;
    
    if (matches == nil)
    {
        if (error)
        {
            *error = fetchError;
        }
    }
    else if (matches.count == 0)
    {
        artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
        artist.name = name;
        artist.smallImage = smallImage;
        
        NSError* saveError = nil;
        [context save:&saveError];
        if (error)
        {
            *error = saveError;
        }
    }
    else
    {
        artist = [matches lastObject];
    }
    return artist;
}

+ (Artist *)updateImage:(NSData *)artistImage
             artistName:(NSString *)artistName
 inManagedObjectContext:(NSManagedObjectContext *)context
                  error:(NSError **)error
{
    NSFetchRequest* artistRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    artistRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", artistName];
    
    NSError* fetchError = nil;
    NSArray* matches = [context executeFetchRequest:artistRequest error:&fetchError];
    
    Artist* artist = nil;
    if (matches == nil)
    {
        if (error)
        {
            *error = fetchError;
        }
    }
    else if (matches.count == 1)
    {
        artist = [matches lastObject];
        artist.smallImage = artistImage;
        
        NSError* saveError = nil;
        [context save:&saveError];
        if (error)
        {
            *error = saveError;
        }
    }
    return artist;
}

+ (void)deleteAllArtists:(NSManagedObjectContext *)context
                   error:(NSError **)error
{
    NSError* fetchError = nil;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    request.predicate = nil;
    
    NSArray* matches = [context executeFetchRequest:request error:&fetchError];
    
    if (fetchError)
    {
        if (error)
        {
            *error = fetchError;
        }
    }
    else if (matches.count > 0)
    {
        for (NSManagedObject* artist in matches)
        {
            [context deleteObject:artist];
        }
        
        NSError* saveError = nil;
        [context save:&saveError];
        if (error)
        {
            *error = saveError;
        }
    }
}

@end
