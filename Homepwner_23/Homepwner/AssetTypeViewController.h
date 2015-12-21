//
//  AssetTypeViewController.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/17.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Item;

@interface AssetTypeViewController : UITableViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) void (^dismissBlock) (void);
@end
