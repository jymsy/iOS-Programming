//
//  PickDateViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/28.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "PickDateViewController.h"
#import "Item.h"

@interface PickDateViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *createDate;

@end

@implementation PickDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", self.createDate.date);
    
    self.item.dateCreated = self.createDate.date;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.createDate.date = self.item.dateCreated;
    
}

- (void)setItem:(Item *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
