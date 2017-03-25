//
//  MyViewPager.m
//  
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "USKPagerView.h"

const int MIN_MOVE_TO_CHANGE_PAGE = 120;

@implementation USKPagerView
{
    CGPoint startTouchPoint ,endTouchPoint;
    USKPageView *currenPageView, *adjacentNext,*adjacentPrev;
    int offsetX,offsetY;
    BOOL adjucentPagesLoaded;
    BOOL pendingPageAnimCompleted;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UILongPressGestureRecognizer *longPressGest= [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(onLongPress:)];
        [self addGestureRecognizer:longPressGest];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) initWithPageView:(USKPageView *) view
{
    adjucentPagesLoaded = NO;
    [self removeAllSubViews:self];
    
    currenPageView = view;
    [self addSubview:currenPageView];
    pendingPageAnimCompleted = YES;
    
    [self checkAdjacentPagesLoaded];
    [_delegate didPageChange: currenPageView];
}

- (void) onLongPress:(UILongPressGestureRecognizer *) gesture
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            startTouchPoint = touchLocation;
            offsetX = 0;
            offsetY = 0;
        }
        [self checkAdjacentPagesLoaded];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            if(touchLocation.x<startTouchPoint.x)
            {
                //flipping to next page
                if(currenPageView)
                {
                    if(adjacentNext)
                    {
                        offsetX = -(startTouchPoint.x-touchLocation.x);
                        if(offsetX>=-self.frame.size.width)
                        {
                            currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjacentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
                        }
                    }
                }
            }
            else if(touchLocation.x>startTouchPoint.x)
            {
                //flipping to previuos page
                if(currenPageView)
                {
                    if(adjacentPrev)
                    {
                        offsetX=(touchLocation.x-startTouchPoint.x);;
                        if(offsetX<=self.frame.size.width)
                        {
                            currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
                            adjacentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
                        }
                    }
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(pendingPageAnimCompleted)
    {
        for (UITouch *touch in touches)
        {
            CGPoint touchLocation = [touch locationInView:self];
            endTouchPoint = touchLocation;
            
            if((startTouchPoint.x-endTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE )
            {
                //flip success
                //moving forward direction
                if(adjacentNext)
                {
                    //animate remaining page move
                    pendingPageAnimCompleted = NO;
                    [self performSelector:@selector(completeNextPageAnimation) withObject:self afterDelay:0.0 ];
                }
            }
            else if((endTouchPoint.x-startTouchPoint.x)>MIN_MOVE_TO_CHANGE_PAGE)
            {
                //moving backward direction
                if(adjacentPrev)
                {
                    //animate remaining page move
                    pendingPageAnimCompleted = NO;
                    [self performSelector:@selector(completePreviousPageAnimation) withObject:self afterDelay:0.0 ];
                }
            }
            else
            {
                //revert flip since not considered as successfull flip
                currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                if(adjacentPrev)
                {
                    adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                }
                if(adjacentNext)
                {
                    adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                }
            }
        }
    }
}

- (void) completeNextPageAnimation
{
    offsetX =offsetX - 5;
    if(ABS(offsetX)>=self.frame.size.width)
    {
        pendingPageAnimCompleted = YES;
    }
    else
    {
        currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
        adjacentNext.frame = CGRectMake(offsetX+self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    if(pendingPageAnimCompleted)
    {
        if(adjacentPrev)
        {
            [self destroyPageView:adjacentPrev];
        }
        adjacentPrev =currenPageView;
        currenPageView = adjacentNext;
        adjacentNext = [_delegate getNextPage:currenPageView];
        [self addSubview: adjacentNext];
        
        currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjacentPrev)
        {
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjacentNext)
        {
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        pendingPageAnimCompleted = YES;
        [self didPageFlipCompleted];
    }
    else
    {
        [self performSelector:@selector(completeNextPageAnimation) withObject:self afterDelay:0.0 ];
    }
}

- (void) completePreviousPageAnimation
{
    offsetX = offsetX + 5;
    if(ABS(offsetX)>=self.frame.size.width)
    {
        pendingPageAnimCompleted = YES;
    }
    else
    {
        currenPageView.frame = CGRectMake(offsetX, offsetY, self.frame.size.width, self.frame.size.height);
        adjacentPrev.frame = CGRectMake(offsetX-self.frame.size.width, offsetY, self.frame.size.width, self.frame.size.height);
    }
    
    
    if(pendingPageAnimCompleted)
    {
        if(adjacentNext)
        {
            [self destroyPageView:adjacentNext];
        }
        adjacentNext = currenPageView;
        currenPageView = adjacentPrev;
        adjacentPrev = [_delegate getPreviousPage:currenPageView];
        [self addSubview: adjacentPrev];
        
        currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(adjacentPrev)
        {
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        if(adjacentNext)
        {
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
        [self didPageFlipCompleted];
    }
    else
    {
        [self performSelector:@selector(completePreviousPageAnimation) withObject:self afterDelay:0.0 ];
    }
}

- (void) settlePageWithAnim:(BOOL) shouldAnimate
{
    
}

- (void) refreshAdjacentPages
{
    if(adjacentNext)
    {
        USKPageView *mpv = (USKPageView *)adjacentNext;
        [mpv refreshPage];
    }
    if(adjacentPrev)
    {
        USKPageView *mpv = (USKPageView *)adjacentPrev;
        [mpv refreshPage];
    }
}

- (void) didPageFlipCompleted
{
    [_delegate didPageChange: currenPageView];
}

- (void) checkAdjacentPagesLoaded
{
    if(!adjacentNext)
    {
        adjacentNext = [_delegate getNextPage:currenPageView];
        if(adjacentNext)
        {
            [self addSubview: adjacentNext];
            adjacentNext.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    if(!adjacentPrev)
    {
        adjacentPrev = [_delegate getPreviousPage:currenPageView];
        if(adjacentPrev)
        {
            [self addSubview: adjacentPrev];
            adjacentPrev.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    if(currenPageView)
    {
        currenPageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

- (USKPageView *) getCurrentPageView
{
    return currenPageView;
}

- (void) removeAllSubViews:(UIView *) parentView
{
    
    NSArray *viewsToRemove = [parentView subviews];
    for (UIView *v in viewsToRemove)
    {
        if(v.class == USKPageView.class)
        {
            [self destroyPageView:(USKPageView *)v];
        }
    }
    
    adjacentPrev= nil;
    adjacentNext= nil;
    currenPageView= nil;
}

- (void) destroyPageView:(USKPageView *) pageView
{
    [pageView removeFromSuperview];
    
    pageView = nil;
}

- (void) onSingleTap:(UIGestureRecognizer *) gestureRecognizer
{
    
}

@end
