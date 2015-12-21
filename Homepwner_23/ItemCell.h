//
//  ItemCell.h
//  Homepwner
//
//  Created by 蒋羽萌 on 15/11/29.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) void (^actionBlock)(void);

@end
