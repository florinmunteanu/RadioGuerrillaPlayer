
#import <Foundation/Foundation.h>
#import "FavoriteSong.h"

typedef enum { FavoriteSongNoState = 0, FavoriteSongSavedSuccessfully = 1, FavoriteSongAlreadyAdded = 2 } FavoriteSongState;

@interface FavoriteSongResult : NSObject

@property (strong, nonatomic) FavoriteSong * song;

@property (nonatomic) FavoriteSongState resultState;

- (instancetype)initWithFavoriteSong:(FavoriteSong *)favoriteSong andState:(FavoriteSongState)state;

@end
