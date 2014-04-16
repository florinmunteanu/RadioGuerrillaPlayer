
#import <Foundation/Foundation.h>
#import "ArtistInfoResponse.h"

@interface LastfmClient : NSObject

- (id)initWithApiKey:(NSString *)apiKey;

- (void)sendGetArtistInfo:(NSString *)artistName withCompletionHandler:(void (^)(ArtistInfoResponse *))completionHandler;

@end
