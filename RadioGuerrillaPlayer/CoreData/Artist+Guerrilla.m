//
//  Artist+Guerrilla.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "Artist+Guerrilla.h"

@implementation Artist (Guerrilla)

+ (Artist *)withName:(NSString *)name
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
        *error = fetchError;
    }
    else if (matches.count == 0)
    {
        artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
        artist.name = name;
        artist.smallImage = smallImage;
    }
    else
    {
        artist = [matches lastObject];
    }
    return artist;
}

@end
