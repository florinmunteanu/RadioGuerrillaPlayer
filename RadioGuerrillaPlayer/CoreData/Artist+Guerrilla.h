//
//  Artist+Guerrilla.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "Artist.h"

@interface Artist (Guerrilla)

+ (Artist *)withName:(NSString *)name
          smallImage:(NSData *)smallImage
inManagedObjectContext:(NSManagedObjectContext *)context
               error:(NSError **)error;

@end
