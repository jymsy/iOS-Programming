//
//  ItemStore.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/18.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"

@interface ItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ItemStore

+(instancetype)sharedStore
{
    static ItemStore *sharedStore = nil;
//    if (!sharedStore) {
//        sharedStore = [[self alloc]initPrivate];
//    }
    
    //线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore =[[self alloc]initPrivate];
    });
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"use +[sharedStore]" userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(void)removeItem:(Item *)item
{
    [[ImageStore sharedStore] deleteImageForKey:item.itemKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(Item *)createItem
{
    Item *item = [Item randomItem];
    [self.privateItems addObject:item];
    return item;
}

@end
