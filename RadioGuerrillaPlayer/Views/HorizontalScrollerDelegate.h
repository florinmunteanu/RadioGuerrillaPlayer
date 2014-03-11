//
//  HorizontalScrollerDelegate.h
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 07/03/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HorizontalScroller.h"

@protocol HorizontalScrollerDelegate <NSObject>

@required

// How many views to present inside the horizontal scroller
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller;

// Return the view that should appear at <index>
- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;

// Inform that the view at <index> has been clicked
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index;

@optional

// The index of the initial view to display. This method is optional
// and defaults to 0 if it's not implemented.
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller;

@end
