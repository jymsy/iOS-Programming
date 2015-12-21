//
//  Item+CoreDataProperties.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/14.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, strong) NSString *itemName;
@property (nullable, nonatomic, strong) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, strong) NSDate *dateCreated;
@property (nullable, nonatomic, strong) NSString *itemKey;
@property (nullable, nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, strong) NSManagedObject *assetType;

@end

NS_ASSUME_NONNULL_END
