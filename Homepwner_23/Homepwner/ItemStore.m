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
@import CoreData;

@interface ItemStore()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
//        _privateItems = [[NSMutableArray alloc]init];
//        NSString *path = [self itemArchivePath];
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        
//        if (!_privateItems) {
//            _privateItems = [[NSMutableArray alloc]init];
//        }
        //读取homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //设置sqlite文件路径
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        [self loadAllItems];
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
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(Item *)createItem
{
//    Item *item = [Item randomItem];
//    Item *item = [[Item alloc] init];
    
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", [self.privateItems count], order);
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                               inManagedObjectContext:self.context];
    item.orderingValue = order;
    [self.privateItems addObject:item];
    return item;
}

-(BOOL)saveChanges
{
//    NSString *path = [self itemArchivePath];
//    
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"error saving:%@", [error localizedDescription]);
    }
    return successful;
}

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取唯一的一个文档目录路径
    NSString *documentDirectory = [documentDirectories firstObject];
    NSLog(@"%@", documentDirectory);
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
//    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    Item *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];

    double lowerBound = 0.0;
    
    if (toIndex >0) {
        lowerBound = [self.privateItems[(toIndex -1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] -2.0;
    }
    double upperBound = 0.0;
    
    if (toIndex < [self.privateItems count] -1) {
        upperBound = [self.privateItems[toIndex +1] orderingValue];
    } else {
        upperBound = [self.privateItems[toIndex -1] orderingValue] +2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) /2.0;
    item.orderingValue = newOrderValue;
}

-(void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Item"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"fetch failed" format:@"reason: %@",[error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"AssetType"
                                             inManagedObjectContext:self.context];
        request.entity =e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"fetch failed" format:@"reason: %@",[error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    //第一次运行?
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
        [type setValue:@"Funniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    return _allAssetTypes;
}

@end
