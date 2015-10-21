//
//  ItemsViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/18.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface ItemsViewController()

@property (nonatomic) NSArray *sectionTitle;

@end

@implementation ItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i=0; i<5; i++) {
            [[ItemStore sharedStore] createItem];
        }
    }
    
    self.sectionTitle = @[@">50", @"others"];
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [backImageView setImage:[UIImage imageNamed:@"003.jpg"]];
    self.tableView.backgroundView=backImageView;
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitle objectAtIndex:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return [[[ItemStore sharedStore] over50Items]count];
    } else {
        return [[[ItemStore sharedStore] otherItems]count] +1;
    }
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView* myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor clearColor];
//    return myView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&& indexPath.row == [[[ItemStore sharedStore] otherItems]count]) {
        return 44.0;
    } else {
        return 60.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:@"UITableViewCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];//背景透明，能够显示背景图

    NSArray *over50items = [[ItemStore sharedStore] over50Items];
    NSArray *otherItems = [[ItemStore sharedStore] otherItems];
    Item *item;
    if (indexPath.section == 0) {
        item = over50items[indexPath.row];
    } else {
        if ([otherItems count] == indexPath.row) {
            cell.textLabel.text = @"No more items!";
            return cell;
        } else {
            item = otherItems[indexPath.row];
        }
    }
//    Item *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

@end
