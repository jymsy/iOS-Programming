//
//  ItemStore.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/18.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSArray *over50Items;
@property (nonatomic, readonly) NSArray *otherItems;

-(Item *)createItem;
+(instancetype)sharedStore;

@end
