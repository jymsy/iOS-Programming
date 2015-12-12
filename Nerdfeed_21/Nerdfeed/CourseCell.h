//
//  CourseCell.h
//  Nerdfeed
//
//  Created by 蒋羽萌 on 15/12/12.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *startDate;

@end
