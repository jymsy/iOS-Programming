//
//  HypnosisViewController.m
//  HypnoNerd
//
//  Created by 蒋羽萌 on 15/10/11.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@interface HypnosisViewController()

//@property (nonatomic) UISegmentedControl *segCtrl;

@end

@implementation HypnosisViewController

-(void)loadView
{
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc]initWithItems:@[@"red",@"green",@"blue"]];

    HypnosisView *backgroundView = [[HypnosisView alloc]init];
    
    [backgroundView addSubview:segCtrl];
//    [self.view addSubview:backgroundView];
    self.view = backgroundView;
    
    [segCtrl addTarget:backgroundView action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title=@"Hypnotize";
        
        UIImage *i=[UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image=i;
    }
    return self;
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

//-(IBAction)changeColor:(id)sender
//{
//    NSInteger index = self.segCtrl.selectedSegmentIndex;
//    NSLog(@"%@", @(index));
//}

@end
