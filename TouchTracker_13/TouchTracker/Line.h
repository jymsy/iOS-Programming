//
//  Line.h
//  TouchTracker
//
//  Created by 蒋羽萌 on 15/11/2.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Line : NSObject

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) CGFloat width;
@property (nonatomic) NSTimeInterval startTime;

@end
