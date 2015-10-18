//
//  Item.h
//  Randomitems
//
//  Created by 蒋羽萌 on 15/10/9.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;

-(instancetype)initWithName:(NSString *)name
             valueInDollars:(int)value
               serialNumber:(NSString *)sNumber;

-(instancetype)initWithName:(NSString *)name;

+(instancetype)randomItem;


-(instancetype)initWithNameS:(NSString *)name serialNumber:(NSString *)number;


@end
