//
//  DrawView.m
//  TouchTracker
//
//  Created by 蒋羽萌 on 15/11/2.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "DrawView.h"
#import "Line.h"

@interface DrawView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) Line *selectedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@end

@implementation DrawView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc] init];
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired =2;//default 1
        doubleTap.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        doubleTap.delaysTouchesBegan = YES;
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:press];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;//是否阻止touch事件在view中被捕获
        [self addGestureRecognizer:self.moveRecognizer];
    }
    return  self;
    
}

-(void)moveLine:(UIPanGestureRecognizer *)gr
{
    NSLog(@"move line");
    if (!self.selectedLine || self.selectedLine != [self lineAtPoint:[gr locationInView:self]]) {
        self.selectedLine = nil;
         [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return;
    }
    NSLog(@"selected line");
    if (gr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gr translationInView:self];
        
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x+= translation.x;
        begin.y +=translation.y;
        end.x +=translation.x;
        end.y +=translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer) {
//        NSLog(@"gesture moved");
        return YES;
    }
    return NO;
}

-(void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if(gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

-(Line *)lineAtPoint:(CGPoint) p
{
    for (Line *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        for (float t =0.0; t<=1.0; t+=0.05) {
            float x = start.x + t*(end.x - start.x);
            float y = start.y +t*(end.y- start.y);
            
            if (hypot(x-p.x, y-p.y) < 20.0) {
                return l;
            }
        }
    }
    return nil;
}

-(void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"tap");
    
    CGPoint p =[gr locationInView:self];
    self.selectedLine = [self lineAtPoint:p];
    
    if (self.selectedLine) {
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        [menu setTargetRect:CGRectMake(p.x, p.y, 2,2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }else{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

-(void)deleteLine:(id)sender
{
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"double tap");
    
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
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

-(void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];
    for (Line * line in self.finishedLines) {
        [self strokeLine:line];
    }
//    NSLog(@"draw rect");

    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
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
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        Line *line = [[Line alloc] init];
        line.begin = location;
        line.end = location;
        
        self.linesInProgress[[NSValue valueWithNonretainedObject:t]] = line;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UITouch *t = [touches anyObject];
//    
//    CGPoint location = [t locationInView:self];
//    self.currentLine.end = location;
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
//    self.selectedLine = nil;
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        Line *line =  self.linesInProgress[[NSValue valueWithNonretainedObject:t]];
        line.end = location;
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine = nil;
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        Line *line =  self.linesInProgress[[NSValue valueWithNonretainedObject:t]];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:[NSValue valueWithNonretainedObject:t]];
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
