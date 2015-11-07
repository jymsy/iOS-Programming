//
//  DrawView.m
//  TouchTracker
//
//  Created by 蒋羽萌 on 15/11/2.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "DrawView.h"
#import "Line.h"
#import "Circle.h"

@interface DrawView()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) NSMutableDictionary *circlesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedCircles;
@end

@implementation DrawView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc] init];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedCircles = [[NSMutableArray alloc] init];
        self.circlesInProgress = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return  self;
}

-(void)strokeLine:(Line *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth=10;
    bp.lineCapStyle = kCGLineCapRound;//线的两端是半圆
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(void)strokeCircle:(Circle *)circle
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth= 5;
    [bp addArcWithCenter:circle.center
                  radius:circle.radius
              startAngle:0.0 endAngle:M_PI * 2.0
               clockwise:YES];
    
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];
    for (Line * line in self.finishedLines) {
        //反正切
        CGFloat radians = atan2f(line.end.y - line.begin.y, line.end.x- line.begin.x);
        //弧度转角度
        
        CGFloat degree = radians * 180 / M_PI;
        if (degree <0) {
            degree += 360;
        }
        NSLog(@"%f", degree);
        if (degree<=90) {
            [[UIColor greenColor] set];
        } else if (degree <= 180) {
            [[UIColor yellowColor] set];
        } else if (degree <= 270) {
            [[UIColor blueColor] set];
        } else {
            [[UIColor blackColor] set];
        }
        [self strokeLine:line];
    }
//    NSLog(@"draw rect");

    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    
    for (Circle *circle in self.finishedCircles)
    {
        [self strokeCircle:circle];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine = [[Line alloc] init];
//    self.currentLine.begin=location;
//    self.currentLine.end=location;
    
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    if ([touches count] !=2) {
        for (UITouch *t in touches) {
            CGPoint location = [t locationInView:self];
            Line *line = [[Line alloc] init];
            line.begin = location;
            line.end = location;
            
            self.linesInProgress[[NSValue valueWithNonretainedObject:t]] = line;
        }
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    if ([touches count] !=2) {
        for (UITouch *t in touches) {
            CGPoint location = [t locationInView:self];
            
            Line *line =  self.linesInProgress[[NSValue valueWithNonretainedObject:t]];
            line.end = location;
        }
    } else {
        //        CGFloat radians = atan2f(line.end.y - line.begin.y, line.end.x- line.begin.x);
        //        CGFloat degree = radians * 180 / M_PI;
        //        NSLog(@"%f", degree);
    }

    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine = nil;
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([touches count] != 2) {
        for (UITouch *t in touches) {
            Line *line =  self.linesInProgress[[NSValue valueWithNonretainedObject:t]];
            [self.finishedLines addObject:line];
            [self.linesInProgress removeObjectForKey:[NSValue valueWithNonretainedObject:t]];
        }
    } else {
        NSArray *touchesArray = [touches allObjects];
        UITouch *t1 = [touchesArray objectAtIndex:0];
        UITouch *t2 = [touchesArray objectAtIndex:1];
        
        CGPoint location1 = [t1 locationInView:self];
        CGPoint location2 = [t2 locationInView:self];
        
        Circle *circle = [[Circle alloc] init];
        CGPoint center;
        center.x = (location1.x + location2.x) / 2.0;
        center.y =(location1.y + location2.y) / 2.0;
        circle.center = center;
        
        CGFloat tx =(location1.x - location2.x) * (location1.x - location2.x);
        CGFloat ty =(location1.y - location2.y) * (location1.y - location2.y);
        
        circle.radius = sqrtf(tx +ty) / 2.0;
//        NSLog(@"%f", circle.radius);
        [self.finishedCircles addObject:circle];
    }

    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        [self.linesInProgress removeObjectForKey:[NSValue valueWithNonretainedObject:t]];
    }
}

@end
