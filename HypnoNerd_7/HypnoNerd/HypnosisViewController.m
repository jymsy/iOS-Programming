//
//  HypnosisViewController.m
//  HypnoNerd
//
//  Created by 蒋羽萌 on 15/10/11.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

@interface HypnosisViewController() <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic) HypnosisView *backgroundView;

@end

@implementation HypnosisViewController

-(void)loadView
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *=2.0;
    
    self.backgroundView = [[HypnosisView alloc]initWithFrame:bigRect];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [scrollView addSubview:self.backgroundView];
    scrollView.contentSize = screenRect.size;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    
    
    CGRect textFieldRect=CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc]initWithFrame:textFieldRect];
    
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.placeholder=@"Hypnotize";
    textField.returnKeyType=UIReturnKeyDone;
    
    textField.delegate=self;
    
    [self.backgroundView addSubview:textField];
    
//    self.view = backgroundView;
    self.view = scrollView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.backgroundView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"%@", textField.text);
    [self drawHypnoticMessage:textField.text];
    
    textField.text=@"";
    [textField resignFirstResponder];
    return YES;
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

-(void)drawHypnoticMessage:(NSString *)message
{
    for (int i=0; i<20; i++) {
        UILabel *messageLabel = [[UILabel alloc]init];
        
        messageLabel.backgroundColor =[UIColor clearColor];
        messageLabel.textColor=[UIColor whiteColor];
        messageLabel.text=message;
        
        //根据需要显示的文字调整UILabel对象的大小
        [messageLabel sizeToFit];
        
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin =CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect =[[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}

@end
