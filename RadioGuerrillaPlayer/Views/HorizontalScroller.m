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

// Stanford CS193p Developing Applications for iOS Fall 2013-14
// initWithFrame is NOT called for a UIView coming out of a storyboard!
// But awakeFromNib is.
-(void)awakeFromNib
{
    [self setupScroller];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupScroller];
    }
    return self;
}

- (void)setupScroller
{
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
    scroller.delegate = self;
    [self addSubview:scroller];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
    [scroller addGestureRecognizer:tapRecognizer];
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
}

- (void)didMoveToSuperview
{
    [self reload];
}

- (void)drawRect:(CGRect)rect
{
    [scroller setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
}

@end
