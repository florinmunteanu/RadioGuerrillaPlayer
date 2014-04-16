
#import "FavoriteSongResult.h"

@implementation FavoriteSongResult

- (instancetype)initWithFavoriteSong:(FavoriteSong *)favoriteSong andState:(FavoriteSongState)state
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
