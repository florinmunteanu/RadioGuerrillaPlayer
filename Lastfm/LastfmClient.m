//
//  LastfmClient.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 15/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//
//  Client for REST calls to Last.fm public API.
//  Documentation for available at http://www.last.fm/api

#import "LastfmClient.h"
#import "ArtistInfo.h"
#import "ArtistInfoResponse.h"

@interface LastfmClient()

/*  The copy attribute is an alternative to strong. 
 *  Instead of taking ownership of the existing object, it creates a copy of whatever you assign to the property,
 *  then takes ownership of that.
 *
 *  Only objects that conform to the NSCopying protocol can use this attribute.
 */

@property (nonatomic, copy) NSString * apiKey;

@end

@implementation LastfmClient

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

NSString * const lastFmApiUrl = @"http://ws.audioscrobbler.com/2.0/";

- (id)initWithApiKey:(NSString *)apiKey
{
    self = [super init];
    
    if (self != nil)
    {
        self.apiKey = apiKey;
    }
    
    return self;
}

/*
 * {
     "artist": {
                 "name":"Cher",
                 "mbid":"bfcc6d75-a6a5-4bc6-8282-47aec8531818",
                 "url":"http:\/\/www.last.fm\/music\/Cher",
                 "image":[
                            {"#text":"http:\/\/userserve-ak.last.fm\/serve\/34\/93299741.png","size":"small"},
                            {"#text":"http:\/\/userserve-ak.last.fm\/serve\/64\/93299741.png","size":"medium"},
                            {"#text":"http:\/\/userserve-ak.last.fm\/serve\/126\/93299741.png","size":"large"},
                            {"#text":"http:\/\/userserve-ak.last.fm\/serve\/252\/93299741.png","size":"extralarge"},
                            {"#text":"http:\/\/userserve-ak.last.fm\/serve\/_\/93299741\/Cher.png","size":"mega"}
                         ],
                 "streamable":"1",
                 "ontour":"1",
                 "stats":{"listeners":"891982","playcount":"10727102"},
                 "similar":{
                             "artist":[
                                        {
                                         "name":"Sonny & Cher",
                                         "url":"http:\/\/www.last.fm\/music\/Sonny+&+Cher",
                                         "image":[
                                                    {"#text":"http:\/\/userserve-ak.last.fm\/serve\/34\/32340147.png","size":"small"},
                                                    ...
                                                 ]
                                         }
                                      ]
                            },
                 "tags":{
                         "tag":[
                                 {"name":"pop","url":"http:\/\/www.last.fm\/tag\/pop"}
                               ]
                        },
                 "bio": {
                          "links":{"link":{"#text":"","rel":"original","href":"http:\/\/www.last.fm\/music\/Cher\/+wiki"}},
                          "published":"Wed, 11 Sep 2013 19:55:28 +0000",
                          "summary":"...",
                          "content":"...",
                          "yearformed":"1965",
                          "formationlist":{"formation":{"yearfrom":"1965","yearto":""}}
                        }
               }
   }
 
 */
- (void)sendGetArtistInfo:(NSString *)artistName withCompletationHandler:(void (^)(ArtistInfoResponse *))completionHandler
{
    if (artistName == nil || artistName.length == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler)
            {
                completionHandler(nil);
            }
        });
        return;
    }
    
    dispatch_async(kBgQueue, ^{
        ArtistInfoResponse* artistInfoReponse = [[ArtistInfoResponse alloc] init];
        
        NSString* artistInfoUrl = [NSString stringWithFormat:@"%@?method=artist.getInfo&artist=%@&api_key=%@&format=json", lastFmApiUrl, artistName, self.apiKey];
        NSURL* url = [NSURL URLWithString:artistInfoUrl];
    
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        NSError* connectionError = nil;
        NSURLResponse* response = nil;
        
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&connectionError];
        
        if (connectionError)
        {
            artistInfoReponse.error = connectionError;
        }
        else
        {
            NSInteger code = ((NSHTTPURLResponse *)response).statusCode;
            if (code == 200 && data != nil)
            {
                artistInfoReponse = [self parseData:data];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler)
            {
                completionHandler(artistInfoReponse);
            }
        });
    });
}

- (ArtistInfoResponse *)parseData:(NSData *)data
{
    ArtistInfoResponse* response = [[ArtistInfoResponse alloc] init];
    if (data == nil)
    {
        return response;
    }
    
    NSError* jsonError = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if (jsonError)
    {
        response.error = jsonError;
        return response;
    }
    // objectForKey returns nil if a key doesn't exist
    
    NSDictionary* artist = [json objectForKey:@"artist"];
    if (artist == nil)
    {
        return response;
    }
    response.artistInfo = [[ArtistInfo alloc] init];
    
    NSArray* images = [artist objectForKey:@"image"];
    [self iterateImages:images forArtistInfo:response.artistInfo];
    
    return response;
}

- (void)iterateImages:(NSArray *)images forArtistInfo:(ArtistInfo *)artistInfo
{
    if (images == nil || images.count == 0)
    {
        return;
    }
    for (NSDictionary* image in images)
    {
        NSString* imageURL = [image objectForKey:@"#text"];
        if (imageURL)
        {
            NSString* size = [image objectForKey:@"size"];
            if ([size isEqualToString:@"small"])
            {
                artistInfo.smallImageURL = imageURL;
            }
            else if ([size isEqualToString:@"medium"])
            {
                artistInfo.mediumImageURL = imageURL;
            }
            else if ([size isEqualToString:@"large"])
            {
                artistInfo.largeImageURL = imageURL;
            }
        }
    }
}

@end
