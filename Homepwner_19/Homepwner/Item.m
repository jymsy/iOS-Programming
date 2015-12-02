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

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    return self;
}

-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    //缩略图大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    //确定缩放倍数并保持宽高比不变
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    //创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    //创建圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    //让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height)/2;
    
    //在上下文中绘制图片
    [image drawInRect:projectRect];
    
    UIImage *smallimage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallimage;
    
    //清理图形上下文
    UIGraphicsEndImageContext();
    
}

@end
