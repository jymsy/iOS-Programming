//
//  HypnosisViewController.m
//  Hypnosisiter
//
//  Created by 蒋羽萌 on 15/10/10.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@interface HypnosisViewController ()

@end

@implementation HypnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    CGRect firstFrame = CGRectMake(160, 240, 100, 150);
    CGRect firstFrame = self.view.bounds;
    HypnosisView *firstView = [[HypnosisView alloc]initWithFrame:firstFrame];
//    firstView.backgroundColor=[UIColor redColor];
    [self.view addSubview:firstView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
