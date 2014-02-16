//
//  LastfmClient.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 15/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArtistInfoResponse.h"

@interface LastfmClient : NSObject

- (id)initWithApiKey:(NSString *)apiKey;

- (void)sendGetArtistInfo:(NSString *)artistName withCompletationHandler:(void (^)(ArtistInfoResponse *))completionHandler;

@end
