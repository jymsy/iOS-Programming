//
//  ImageStore.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/31.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+(instancetype)sharedStore;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;

@end
