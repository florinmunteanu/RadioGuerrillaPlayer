//
//  HorizontalScroller.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 07/03/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end
