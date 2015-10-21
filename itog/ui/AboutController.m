//
//  AboutController.m
//  itog
//
//  Created by Shuwei on 15/10/19.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController{
    MBProgressHUD *hud;
    UIWebView *web;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关于应用";
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    web = [[UIWebView alloc] initWithFrame:self.view.frame];
    web.delegate=self;
    [self.view addSubview:web];
    self.view.backgroundColor=[UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [web loadHTMLString:html baseURL:nil];
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
@end
