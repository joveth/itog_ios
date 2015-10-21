//
//  WebController.m
//  itog
//
//  Created by Shuwei on 15/10/15.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "WebController.h"

@interface WebController ()

@end

@implementation WebController{
    MBProgressHUD *hud;
    BlogBean *bean;
    UIWebView *web;
    DBHelper *db;
    UIBarButtonItem *rightItem;
    BOOL added;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bean = [ShareData shareInstance].blog;
    self.title=bean.title;
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    web = [[UIWebView alloc] initWithFrame:self.view.frame];
    web.delegate=self;
    [self.view addSubview:web];
    self.view.backgroundColor=[UIColor whiteColor];
    db = [DBHelper sharedInstance];
    rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addfav"] style:UIBarButtonItemStyleBordered target:self action:@selector(addFav)];
    rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =rightItem;
    added = NO;
    
    NSString *con =[ db getValueByKey:@"closeAD"];
    if(con&&[con isEqualToString:@"1"]){
        
    }else{
        ADBannerView *bannerView = [[ADBannerView alloc]initWithFrame:
                                    CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
        // Optional to set background color to clear color
        bannerView.delegate=self;
        [bannerView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview: bannerView];
    }
    
}
-(void)addFav{
    if(added){
        return;
    }
    if([db openDB]){
        if([db saveBlog:bean]){
            rightItem.image =[UIImage imageNamed:@"addedfav"];
        }else{
            [Common showMessageWithOkButton:@"收藏失败了"];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MainService getBlogContent:bean.link andType:bean.type andSuccess:^(NSString *result) {
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        html = [html stringByAppendingString:result];
        html  =[html stringByAppendingString:@"</article></body></html>"];
        [web loadHTMLString:html baseURL:baseURL];
    } andError:^(NSInteger code) {
        [hud hide:YES];
        [Common showMessageWithOkButton:@"加载失败了，请稍后再试！"];
    }];
    if([db openDB]){
        if([db getBlogByLink:bean.link]){
            added = YES;
            rightItem.image =[UIImage imageNamed:@"addedfav"];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
}
-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading:%@",error);
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
}
@end
