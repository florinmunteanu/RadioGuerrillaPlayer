//
//  HorizontalScroller.m
//  RadioGuerrillaPlayer
//
//  Created by Florin Munteanu on 07/03/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "HorizontalScroller.h"
#import "HorizontalScrollerDelegate.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 75
#define VIEW_OFFSET 5

@protocol HorizontalScrollerDelegate;

@interface HorizontalScroller () <UIScrollViewDelegate>

@end

@implementation HorizontalScroller
{
    UIScrollView* scroller;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        [self addSubview:scroller];
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)scrollerTapped:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroller:self]; index++)
    {
        UIView* view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location))
        {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            //[scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, 0)
            //                  animated:YES];
        }
    }
}

- (void)reload
{
    if (self.delegate == nil)
    {
        return;
    }
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { [obj removeFromSuperview]; }];
    
    CGFloat x = VIEW_OFFSET;
    for (int i = 0; i < [self.delegate numberOfViewsForHorizontalScroller:self]; i++)
    {
        x += VIEW_PADDING;
        UIView* view = [self.delegate horizontalScroller:self viewAtIndex:i];
        
        view.frame = CGRectMake(x, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
        [scroller addSubview:view];
        
        x += VIEW_DIMENSIONS + VIEW_PADDING;
    }
    
    [scroller setContentSize:CGSizeMake(x + VIEW_OFFSET, self.frame.size.height)];
    
    // If an initial view is defined, center the scroller on it
    //if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)])
    //{
    //    NSInteger initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
    //    [scroller setContentOffset:CGPointMake(initialView * (VIEW_DIMENSIONS + 2 * VIEW_PADDING), 0) animated:YES];
    //}
}

- (void)didMoveToSuperview
{
    [self reload];
}
/*
- (void)centerCurrentView
{
    int x = scroller.contentOffset.x + (VIEW_OFFSET / 2) + VIEW_PADDING;
    int viewIndex = x / (VIEW_DIMENSIONS + 2 * VIEW_PADDING);
    x = viewIndex * (VIEW_DIMENSIONS + 2 * VIEW_PADDING);
    
    [scroller setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == FALSE)
    {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}*/

@end
