//
//  MyPopoverBackgroundView.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/11/24.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "MyPopoverBackgroundView.h"

@implementation MyPopoverBackgroundView
@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
    }
    return  self;
}

+ (UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake( 8.0,  8.0,  8.0,  8.0);
}

+ (CGFloat)arrowHeight
{
    return 19.0;
}

+ (CGFloat)arrowBase
{
    return 37.0;
}

-(void) setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

-(void) setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
//    NSLog(@"%@", arrowDirection);
//    _arrowDirection = UIPopoverArrowDirectionUp;
    [self setNeedsLayout];
}

@end
