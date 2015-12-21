//
//  Item.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/14.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "Item.h"

@implementation Item

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

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
    
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

@end
