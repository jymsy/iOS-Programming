//
//  Item.m
//  Randomitems
//
//  Created by 蒋羽萌 on 15/10/9.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "Item.h"

@implementation Item

-(NSString *)description
{
    return [[NSString alloc] initWithFormat:@"%@ (%@): worth $%d, recorded on %@",self.itemName,
            self.serialNumber,self.valueInDollars, self.dateCreated];
}

-(instancetype) initWithName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    if (self) {
        _itemName = name;
        _valueInDollars = value;
        _serialNumber = sNumber;
        
        _dateCreated=[[NSDate alloc]init];
        NSUUID *uuid = [[NSUUID alloc] init];
        _itemKey = [uuid UUIDString];
        
    }
    return self;
}

-(instancetype) initWithName:(NSString *)name
{
    return [self initWithName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)init
{
    return [self initWithName:@"item"];
}

+(instancetype)randomItem
{
    NSArray *randomAdjectiveList=@[@"fluffy", @"rusty", @"shiny"];
    NSArray *randomNounList=@[@"bear", @"spork", @"mac"];
    
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0'+arc4random() %10,
                                    'A'+arc4random()%26,
                                    '0'+arc4random()%10,
                                    'A'+arc4random()%26,
                                    '0'+arc4random() %10];
    
    Item *newItem = [[self alloc]initWithName:randomName
                               valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
    
}

-(instancetype)initWithNameS:(NSString *)name serialNumber:(NSString *)number
{
    return [self initWithName:name valueInDollars:0 serialNumber:number];
}

@end
