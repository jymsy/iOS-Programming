//
//  DetailViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/10/26.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "AssetTypeViewController.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
//@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIPopoverPresentationController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;


@end

@implementation DetailViewController

- (instancetype)initForNewItem:(BOOL)isNew{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
        
    }
    return  self;
}

-(void)dealloc
{
    NSNotificationCenter *defaultcenter =[NSNotificationCenter defaultCenter];
    [defaultcenter removeObserver:self];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"wrong initializer" reason:@"use initForNewItem:" userInfo:nil];
    return nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    self.imageView = iv;
    
    //将imageView的垂直方向优先级设置为比其他视图低的数值
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisHorizontal];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel":self.dateLabel,
                              @"toolbar":self.toolbar};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil
                                                                               views:nameMap];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil
                                                                               views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];;
    [self.view addConstraints:verticalConstraints];
}

-(void)save:(id)sender
{
    NSLog(@"save");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)cancel:(id)sender
{
    [[ItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    //判断设备是否处于横排方向
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

//拍照
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePick.delegate = self;
    
    //创建UIPopoverController对象之前先判断当前设备是否是iPad, 使用popoverPresentationController
    //已经不需要判断
    //http://www.15yan.com/story/jlkJnPmVGzc/
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    NSLog(@"take picture");
        imagePick.modalPresentationStyle = UIModalPresentationPopover;
        self.imagePickerPopover = imagePick.popoverPresentationController;
        self.imagePickerPopover.barButtonItem = sender;
        self.imagePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.imagePickerPopover.delegate = self;
        
//        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePick];
//        
//        self.imagePickerPopover.delegate = self;
//        //sender指向的是代表相机按钮的UIBarButtonItem对象
//        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
//                                        permittedArrowDirections:UIPopoverArrowDirectionAny
//                                                        animated:YES];
        //以模态的方式显示
            [self presentViewController:imagePick animated:YES completion:nil];
}

-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    NSLog(@"user dismiss popover");
    self.imagePickerPopover = nil;
}

-(void)updateFonts
{
    UIFont *font =[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font =font;
    self.valueLabel.font=font;
    self.dateLabel.font=font;
    
    self.nameField.font=font;
    self.serialNumberField.font=font;
    self.valueField.font=font;
}

- (void)setItem:(Item *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
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
    if (item.itemKey) {
        UIImage *image = [[ImageStore sharedStore] imageForKey:item.itemKey];
        
        self.imageView.image = image;
    } else {
        self.imageView.image = nil;
    }

    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type:%@", typeLabel];
    //设置字体
    [self updateFonts];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过info字典获取选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self.item setThumbnailFromImage:image];
    
    [[ImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.imagePickerPopover) {
        self.imagePickerPopover = nil;
    }
}

- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    AssetTypeViewController *atvc = [[AssetTypeViewController alloc] init];
    
    atvc.item = self.item;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        atvc.dismissBlock = ^{
            NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
            if (!typeLabel) {
                typeLabel = @"None";
            }
            
            self.assetTypeButton.title = [NSString stringWithFormat:@"Type:%@", typeLabel];
        };
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:atvc];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navController animated:YES completion:nil];
    
    } else {
        [self.navigationController pushViewController:atvc animated:YES];
    }
}

@end
