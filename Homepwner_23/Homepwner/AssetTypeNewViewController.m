//
//  AssetTypeNewViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/21.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "AssetTypeNewViewController.h"
#import "ItemStore.h"

@interface AssetTypeNewViewController()
@property (weak, nonatomic) IBOutlet UITextField *assetTypeName;

@end

@implementation AssetTypeNewViewController

//-(instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.view.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

-(void)save:(id)sender
{
    NSLog(@"add");
    NSString *assetTypeName = self.assetTypeName.text;
    if ([assetTypeName length] > 0) {
        NSLog(@"%@", assetTypeName);
        [[ItemStore sharedStore] addAssetType:assetTypeName];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
    }
}

@end
