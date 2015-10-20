//
//  ItemStore.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/18.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"

@interface ItemStore()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSMutableArray *privateOver50Items;
@property (nonatomic) NSMutableArray *privateOtherItems;

@end

@implementation ItemStore

+(instancetype)sharedStore
{
    static ItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
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
        _privateOver50Items = [[NSMutableArray alloc]init];
        _privateOtherItems = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(NSArray *)over50Items
{
    return _privateOver50Items;
}

-(NSArray *)otherItems
{
    return _privateOtherItems;
}

-(Item *)createItem
{
    Item *item = [Item randomItem];
    [self.privateItems addObject:item];
    if (item.valueInDollars > 50) {
        [_privateOver50Items addObject:item];
    } else {
        [_privateOtherItems addObject:item];
    }
    return item;
}

@end
