//
//  ArtistInfoWebResponse.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArtistInfo.h"

@interface ArtistInfoResponse : NSObject

@property (nonatomic, strong) ArtistInfo* artistInfo;

@property (nonatomic, strong) NSError* error;

@end
