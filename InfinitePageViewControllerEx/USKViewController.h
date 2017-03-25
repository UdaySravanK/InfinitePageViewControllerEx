//
//  USKViewController.h
//  InfinitePageViewControllerEx
//
//  Created by UdaySravan K on 13/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USKPagerView.h"

@interface USKViewController : UIViewController<USKPagerViewDelegate>
@property (weak, nonatomic) IBOutlet USKPagerView *pagerView;

@end
