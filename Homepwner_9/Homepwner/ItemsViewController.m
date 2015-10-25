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

@property(nonatomic, strong)IBOutlet UIView *headerView;

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
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(IBAction)addNewItem:(id)sender
{
    Item *newItem = [[ItemStore sharedStore] createItem];
    
    NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        [[ItemStore sharedStore] removeItem:items[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //通过该方法表视图可以询问指定行是否可以被删除，或者是否可以将新行插入到指定位置。
    if (indexPath.row == [[[ItemStore sharedStore]allItems]count]) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;

    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //金挑战,完全不能移到最后去
    //致敬: http://stackoverflow.com/questions/849926/how-to-limit-uitableview-row-reordering-to-a-section
    if (proposedDestinationIndexPath.row == [[[ItemStore sharedStore] allItems] count]) {
        //影响:如果返回源格子,那么这里会引起的是,格子到了上面又弹回去,哈!
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[ItemStore sharedStore]allItems]count]) {
        return NO;
    }
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setEditing:YES animated:YES];
    }
}

-(UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allItems]count]+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:@"UITableViewCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    NSArray *items = [[ItemStore sharedStore]allItems];
    if (indexPath.row  == [items count]) {
        cell.textLabel.text = @"no more items!";
    } else {
        Item *item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }

    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

@end
