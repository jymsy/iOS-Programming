//
//  HypnosisView.m
//  Hypnosisiter
//
//  Created by 蒋羽萌 on 15/10/10.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x +bounds.size.width /2.0;
    center.y = bounds.origin.y +bounds.size.height /2.0;
    
//    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    for (float currentRadius = maxRadius; currentRadius>0; currentRadius-=20) {
        
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI*2.0
                     clockwise:YES];
    }

    
    path.lineWidth=10;
    
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
    
    UIBezierPath *tri = [[UIBezierPath alloc]init];
    [tri moveToPoint:CGPointMake(center.x, center.y/2)];
    [tri addLineToPoint:CGPointMake(center.x * 1.5, center.y * 1.5)];
    [tri addLineToPoint:CGPointMake(center.x/ 2.0, center.y*1.5)];
    [tri closePath];
    [tri stroke];
    
    [tri addClip];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8]={1.0,1.0,0.0,1.0,
                                            0.0,1.0,0.0,1.0};
    
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startpoint = CGPointMake(center.x, center.y/2.0);
    CGPoint endpoint = CGPointMake(center.x, center.y*1.5);
    
    CGContextDrawLinearGradient(currentContext, gradient, startpoint, endpoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//
//    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
//    UIImage *img = [UIImage imageNamed:@"logo.png"];
//    [img drawInRect:bounds];
    
}



@end
