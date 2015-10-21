//
//  WebSiteController.m
//  itog
//
//  Created by Shuwei on 15/10/21.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "WebSiteController.h"

@interface WebSiteController ()

@end

@implementation WebSiteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"博主站点";
    self.tableView.header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self load];
    }];
    [self.tableView.header beginRefreshing];
}
-(void)load{
    sleep(5);
    [Common showMessageWithOkButton:@"作者还在整理中，即将完成，如果你也有不错的站点，请发给我哦。" andDelegate:self];
    [self.tableView.header endRefreshing];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==12){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
