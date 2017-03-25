//
//  USKPageView.m
//  
//
//  Created by UdaySravan K on 10/06/14.
//  Copyright (c) 2014 hurix. All rights reserved.
//

#import "USKPageView.h"
#import "USKPagerView.h"

@implementation USKPageView
{
    UIBezierPath *path;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        path = [UIBezierPath bezierPath];
//        [path setLineWidth:2.0];
        NSLog(@"my page view created");
        
    }
    return self;
}

- (void) loadViewWithData:(NSObject *) data
{
    self.backgroundColor = [UIColor blueColor];
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 300, 100)];
    [tv setTextColor:[UIColor blueColor]];
    tv.font = [UIFont boldSystemFontOfSize:20];
    tv.backgroundColor = [UIColor whiteColor];
    [tv setText:[self timeStamp]];
    [self addSubview:tv];
}

- (NSString *) timeStamp
{
    return [NSString stringWithFormat:@"%@",[[NSDate date] description]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSString *)GetCurrentTimeStamp
{
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString    *strTime = [objDateformat stringFromDate:[NSDate date]];
    NSString    *strUTCTime = [self GetUTCDateTimeFromLocalTime:strTime];//You can pass your date but be carefull about your date format of NSDateFormatter.
    NSDate *objUTCDate  = [objDateformat dateFromString:strUTCTime];
    long long milliseconds = (long long)([objUTCDate timeIntervalSince1970] * 1000.0);
    
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    NSLog(@"The Timestamp is = %@",strTimeStamp);
    return strTimeStamp;
}

- (NSString *) GetUTCDateTimeFromLocalTime:(NSString *)IN_strLocalTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  *objDate    = [dateFormatter dateFromString:IN_strLocalTime];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *strDateTime   = [dateFormatter stringFromDate:objDate];
    return strDateTime;
}

- (void)refreshPage
{
    
}
@end
