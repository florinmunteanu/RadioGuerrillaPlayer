
#import <Foundation/Foundation.h>
#import "ArtistInfo.h"

@interface ArtistInfoResponse : NSObject

@property (nonatomic, strong) ArtistInfo* artistInfo;

@property (nonatomic, strong) NSString* artistName;

@property (nonatomic, strong) NSError* error;

@end
