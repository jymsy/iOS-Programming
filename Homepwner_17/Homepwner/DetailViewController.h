//
//  DetailViewController.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/26.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;

@interface DetailViewController : UIViewController

-(instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) void (^dismissBlock) (void);

@end
