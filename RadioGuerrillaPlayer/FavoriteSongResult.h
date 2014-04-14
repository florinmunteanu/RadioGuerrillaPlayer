//
//  FavoriteSongSaveResult.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 13/04/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteSong.h"

typedef enum { FavoriteSongNoState = 0, FavoriteSongSavedSuccessfully = 1, FavoriteSongAlreadyAdded = 2 } FavoriteSongState;

@interface FavoriteSongResult : NSObject

@property (strong, nonatomic) FavoriteSong * song;

@property (nonatomic) FavoriteSongState resultState;

- (id)initWithFavoriteSong:(FavoriteSong *)favoriteSong andState:(FavoriteSongState)state;

@end
