//
//  ItemCell.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/11/29.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
