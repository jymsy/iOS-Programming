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

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation DetailViewController
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)removePicture:(id)sender {
    
    [[ImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    self.imageView.image = nil;
}

//拍照
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
//        CGFloat y =self.view.bounds.origin.y + self.view.bounds.size.height / 2.0;
//        CGFloat x = self.view.bounds.size.width / 2.0;
        
        UIImageView *overLayImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [overLayImg setCenter:imagePick.view.center];
        overLayImg.image = [UIImage imageNamed:@"jd.png"];
        
        imagePick.cameraOverlayView = overLayImg;
    } else {
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
        //    imagePick.showsCameraControls  = YES;
        //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
        imagePick.allowsEditing = YES;
    }
    
    imagePick.delegate = self;
    
    //以模态的方式显示
    [self presentViewController:imagePick animated:YES completion:nil];
}

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
    
    UIImage *image = [[ImageStore sharedStore] imageForKey:item.itemKey];
    self.imageView.image = image;
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
    
//    self.imageView.image = image;
    
    [[ImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
