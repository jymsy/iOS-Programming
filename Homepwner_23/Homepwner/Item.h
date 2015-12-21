//
//  Item.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/14.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
