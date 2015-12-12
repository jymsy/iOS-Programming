//
//  WebViewController.m
//  Nerdfeed
//
//  Created by 蒋羽萌 on 15/12/9.
//  Copyright © 2015年 蒋羽萌. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (nonatomic) UIToolbar *toolBar;
@property (nonatomic) UIWebView *webView;
@property (nonatomic) UIBarButtonItem *back;
@property (nonatomic) UIBarButtonItem *forward;
@end

@implementation WebViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
            self.back =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                 target:self action:@selector(goBack)];
            self.back.enabled = NO;
            self.forward =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                 target:self action:@selector(goForward)];
            self.forward.enabled = NO;
        self.toolbarItems = @[self.back, self.forward];
        
    }
    return self;
}

-(void)loadView
{
    _webView = [[UIWebView alloc]init];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    self.view = _webView;
}


-(void)setUrl:(NSURL *)url
{
//    _url = [NSURL URLWithString:@"www.baidu.com"];
    _url = url;
    if (_url) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_url];
        [(UIWebView *)self.view loadRequest:req];
        NSLog(@"load req");
    }
}

-(void)goBack
{
    [(UIWebView *)self.view goBack];
}

-(void)goForward
{
    [(UIWebView *)self.view goForward];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"start load");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish load");
    self.back.enabled = [webView canGoBack];
    self.forward.enabled = [webView canGoForward];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

@end
