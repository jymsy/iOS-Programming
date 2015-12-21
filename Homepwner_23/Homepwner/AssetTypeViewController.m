//
//  AssetTypeViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/12/17.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "AssetTypeViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "AssetTypeNewViewController.h"

@implementation AssetTypeViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UIBarButtonItem *addAssetType = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addAssetType;
    }
    return self;
}

//-(instancetype)initForPop
//{
//    self = [self init];
//    if (self) {
//        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                  target:self action:@selector(save:)];
//        self.navigationItem.rightBarButtonItem = doneItem;
//        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                    target:self action:@selector(cancel:)];
//        self.navigationItem.leftBarButtonItem = cancelItem;
//    }
//    return self;
//}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)add:(id)sender
{
    NSLog(@"add");
    AssetTypeNewViewController *atnvc = [[AssetTypeNewViewController alloc] initWithNibName:@"AssetTypeNewViewController" bundle:nil];
    [self.navigationController pushViewController:atnvc animated:YES];
}

//-(void)cancel:(id)sender
//{
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allAssetTypes] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    
    cell.textLabel.text = [assetType valueForKey:@"label"];
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:self.dismissBlock];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
