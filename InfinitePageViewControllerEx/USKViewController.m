//
//  USKViewController.m
//  InfinitePageViewControllerEx
//
//  Created by UdaySravan K on 13/08/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "USKViewController.h"

@interface USKViewController ()

@end

@implementation USKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pagerView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    
    USKPageView *page = [[USKPageView alloc] initWithFrame:_pagerView.frame];
    [page loadViewWithData:nil];
    [_pagerView initWithPageView:page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (USKPageView *)getNextPage:(USKPageView *)oldPageView
{
    USKPageView *page = [[USKPageView alloc] initWithFrame:_pagerView.frame];
    [page loadViewWithData:nil];
    page.backgroundColor = [UIColor colorWithRed:[self getRandomColorUnit] green:[self getRandomColorUnit] blue:[self getRandomColorUnit] alpha:1];
    return page;
}

- (USKPageView *)getPreviousPage:(USKPageView *)oldPageView
{
    USKPageView *page = [[USKPageView alloc] initWithFrame:_pagerView.frame];
    [page loadViewWithData:nil];
    page.backgroundColor = [UIColor colorWithRed:[self getRandomColorUnit] green:[self getRandomColorUnit] blue:[self getRandomColorUnit] alpha:1];
    return page;
}

- (void)didPageChange:(USKPageView *)currentPageView
{
    NSLog(@"page changed");
}

- (CGFloat) getRandomColorUnit
{
    
    return randomFloat(0, 1);
}

float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}
@end
