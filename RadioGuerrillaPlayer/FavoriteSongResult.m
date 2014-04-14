//
//  FavoriteSongSaveResult.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 13/04/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "FavoriteSongResult.h"

@implementation FavoriteSongResult

- (id)initWithFavoriteSong:(FavoriteSong *)favoriteSong andState:(FavoriteSongState)state
{
    self = [super init];
    if (self)
    {
        self.song = favoriteSong;
        self.resultState = state;
    }
    return self;
}

@end
