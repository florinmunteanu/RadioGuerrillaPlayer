
#import "Artist.h"

@interface Artist (Guerrilla)

+ (Artist *)getOrAddWithName:(NSString *)name
                  smallImage:(NSData *)smallImage
      inManagedObjectContext:(NSManagedObjectContext *)context
                       error:(NSError **)error;

+ (Artist *)updateImage:(NSData *)artistImage
             artistName:(NSString *)artistName
 inManagedObjectContext:(NSManagedObjectContext *)context
                  error:(NSError **)error;

+ (void)deleteAllArtists:(NSManagedObjectContext *)context
                   error:(NSError **)error;

@end
