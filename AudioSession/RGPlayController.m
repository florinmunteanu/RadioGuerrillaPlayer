//
//  RGPlayController.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 11/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "RGPlayController.h"

@interface RGPlayController()

@property (strong, nonatomic) NSString* currentSong;

@property (strong, nonatomic) NSString* currentArtist;

@end

@implementation RGPlayController

- (void)setStreamTitle:(NSString *)streamTitle
{
    _streamTitle = streamTitle;
    
    NSArray* components = [self.streamTitle componentsSeparatedByString:@"-"];
    if (components.count > 0)
    {
        self.currentArtist =  (NSString *)[components objectAtIndex:0];
        self.currentArtist = [self.currentArtist stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        if (components.count > 1)
        {
            self.currentSong = (NSString *)[components objectAtIndex:1];
            self.currentSong = [self.currentSong stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        }
        else
        {
            self.currentSong = @"";
            
        }
    }
    else
    {
        self.currentArtist = @"";
        self.currentSong = @"";
    }
}

@end
