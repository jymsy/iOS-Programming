//
//  DetailViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/26.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeDateButton;

@end

@implementation DetailViewController

- (void)setItem:(Item *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Item *item = self.item;
    
    self.nameField.text =item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消当前第一响应对象
    [self.view endEditing:YES];
    
    Item * item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

//点击屏幕关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)changeDate:(id)sender{
    NSLog(@"change date");
    PickDateViewController *pickDateViewController = [[PickDateViewController alloc]init];
    pickDateViewController.item = self.item;
    [self.navigationController pushViewController:pickDateViewController animated:YES];
}

@end
