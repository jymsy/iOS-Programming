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

-(Item *)createItem;
+(instancetype)sharedStore;
-(void)removeItem:(Item *)item;
-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

-(BOOL)saveChanges;
-(NSArray *)allAssetTypes;
-(void)addAssetType:(NSString *)name;

@end
