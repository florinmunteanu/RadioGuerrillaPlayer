//
//  Artist.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 16/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * smallImage;

@end
