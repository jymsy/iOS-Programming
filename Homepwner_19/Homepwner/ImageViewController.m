//
//  ImageViewController.m
//  Homepwner
//
//  Created by 蒋羽萌 on 15/11/30.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ImageViewController

-(void)loadView
{
    NSLog(@"load image view");
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    self.imageView.
    NSLog(@"load view finished");
//    CGRect rect = self.view.bounds;
    
    self.imageView.center = CGPointMake(300, 300);
    
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView =[[UIScrollView alloc] init];

//    self.scrollView.contentSize = self.image.size;
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2;
    [self.scrollView addSubview:self.imageView];
    self.view = self.scrollView;
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIImageView *imageView = (UIImageView *)self.view;
//    imageView.image = self.image;
    
}

//使图片居中
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
