//
//  USKPagerView.h
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USKPageView.h"

@protocol USKPagerViewDelegate <NSObject>

@required
- (USKPageView *) getPreviousPage:(USKPageView*) oldPageView;
- (USKPageView *) getNextPage:(USKPageView*) oldPageView;
- (void) didPageChange:(USKPageView *) currentPageView;
@end

@interface USKPagerView : UIView

@property (nonatomic,weak) id<USKPagerViewDelegate> delegate;

- (void) initWithPageView:(USKPageView *) view;
- (void) refreshAdjacentPages;
- (void) checkAdjacentPagesLoaded;
- (USKPageView *) getCurrentPageView;
@end
