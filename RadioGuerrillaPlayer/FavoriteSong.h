
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface FavoriteSong : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSDate * savedDate;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) Artist *artistInfo;

@end
