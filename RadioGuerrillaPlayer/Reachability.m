//
//  Reachability.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 15/02/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Reachability

/*  Documentation available at https://mikeash.com/pyblog/friday-qa-2013-06-14-reachability.html .
 */

- (BOOL)isInternetAvailable
{
    //NSString *google = @"www.google.com";
    //SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [google UTF8String]);
    
    return TRUE;
}

void (^callbackBlock)(SCNetworkReachabilityFlags) = ^(SCNetworkConnectionFlags flags)
{
    //BOOL reachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
};

@end
