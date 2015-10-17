//
//  ReminderViewController.m
//  HypnoNerd
//
//  Created by 蒋羽萌 on 15/10/11.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController() 

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation ReminderViewController

-(IBAction)addReminder:(id)sender
{
    NSDate *date=self.datePicker.date;
    NSLog(@"seting a reminder for %@", date);
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:10];
    UILocalNotification *note=[[UILocalNotification alloc]init];
    note.alertBody=@"fxxk me!";
    note.fireDate=date1;
    note.timeZone = [NSTimeZone defaultTimeZone];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title=@"Reminder";
        
        UIImage *i=[UIImage imageNamed:@"Time.png"];
        self.tabBarItem.image=i;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

@end
