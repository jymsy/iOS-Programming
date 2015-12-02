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
#import "ImageStore.h"
#import "ImageViewController.h"

@interface ItemsViewController() <UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) UIPopoverPresentationController *imagePopover;
@end

@implementation ItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for (int i=0; i<5; i++) {
//            [[ItemStore sharedStore] createItem];
//        }
        self.navigationItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(IBAction)addNewItem:(id)sender
{
    Item *newItem = [[ItemStore sharedStore] createItem];
    
//    NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        [[ItemStore sharedStore] removeItem:items[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailViewController *detailVewController = [[DetailViewController alloc] init];
    DetailViewController *detailVewController = [[DetailViewController alloc] initForNewItem:NO];
    
    Item *item = [[ItemStore sharedStore] allItems][indexPath.row];
    detailVewController.item = item;
    
    [self.navigationController pushViewController:detailVewController animated:YES];
}

//-(IBAction)toggleEditingMode:(id)sender
//{
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        
//        [self setEditing:YES animated:YES];
//    }
//}

//-(UIView *)headerView
//{
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allItems]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:@"UITableViewCell"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
//                                                            forIndexPath:indexPath];
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"
                                                            forIndexPath:indexPath];
    
    NSArray *items = [[ItemStore sharedStore]allItems];
    Item *item = items[indexPath.row];
//    cell.textLabel.text = [item description];
    
    cell.nameLabel.text =[item description];
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    if (item.thumbnail) {
        NSLog(@"has thumbnail");
    }
    cell.thumbnailView.image = item.thumbnail;
    
    __weak ItemCell *weakCell = cell;
    cell.actionBlock = ^{
        NSLog(@"call block");
        
        ItemCell *strongCell = weakCell;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            UIImage *img = [[ImageStore sharedStore] imageForKey:itemKey];
            
            if (!img) {
                return ;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            ImageViewController *ivc = [[ImageViewController alloc] init];
            ivc.image = img;
            
            [ivc setPreferredContentSize:CGSizeMake(600, 600)];
            ivc.modalPresentationStyle = UIModalPresentationPopover;
            self.imagePopover = ivc.popoverPresentationController;
            self.imagePopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.imagePopover.sourceRect = rect;
            self.imagePopover.sourceView = self.view;
            self.imagePopover.delegate = self;
            
            [self presentViewController:ivc animated:YES completion:nil];
            
        }
    };
    return cell;
}

-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    self.imagePopover = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //update data
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
    
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}

@end
