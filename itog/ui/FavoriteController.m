//
//  FavoriteController.m
//  itog
//
//  Created by Shuwei on 15/10/19.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "FavoriteController.h"

@interface FavoriteController ()

@end

@implementation FavoriteController{
    DBHelper *db;
    NSMutableArray *list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的收藏";
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.backgroundColor=[Common colorWithHexString:@"e0e0e0"];
    self.tableView.header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self load];
    }];
    db = [DBHelper sharedInstance];
    list = [[NSMutableArray alloc] init];
    [self.tableView.header beginRefreshing];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStyleBordered target:self action:@selector(delete)];
    rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =rightItem;
    
}
-(void)delete{
    [Common showMessageWithCancelAndOkButton:@"确定清空所有收藏吗？" andTag:10 andDelegate:self ];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10){
        if(buttonIndex==1){
            if([db openDB]){
                [db deleteAllBlogs];
                [list removeAllObjects];
                [self.tableView reloadData];
            }
        }
    }
}
-(void)load{
    if([db openDB]){
        list = [db getAllBlogs];
        if([list count]!=0){
            [self.tableView reloadData];
        }else{
            [Common showMessageWithOkButton:@"亲，您还没有收藏哦！"];
        }
    }
    [self.tableView.header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellidentifier = @"cellIdentifier";
    UITableViewCell    *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    cell.backgroundColor = [UIColor whiteColor];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *nameLabel =(UILabel*)[cell viewWithTag:1];
    UILabel *contentLabel=(UILabel*)[cell viewWithTag:2];
    UILabel *otherLabel=(UILabel*)[cell viewWithTag:3];
    if(nameLabel==nil){
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-16, 22)];
        nameLabel.lineBreakMode=NSLineBreakByWordWrapping;
        nameLabel.numberOfLines=0;
        nameLabel.tag=1;
        nameLabel.textColor=FlatBlue;
        [cell addSubview:nameLabel];
    }
    
    if(contentLabel==nil){
        contentLabel = [[UILabel alloc] init];
        contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        contentLabel.numberOfLines=0;
        contentLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        contentLabel.tag=2;
        contentLabel.textColor=FlatBlackDark;
        [cell addSubview:contentLabel];
    }
    if(otherLabel==nil){
        otherLabel = [[UILabel alloc] init];
        otherLabel.lineBreakMode=NSLineBreakByWordWrapping;
        otherLabel.numberOfLines=0;
        otherLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        otherLabel.tag=3;
        otherLabel.alpha=0.9;
        otherLabel.textColor=FlatBrown;
        [cell addSubview:otherLabel];
    }
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    if(bean){
        nameLabel.text =[NSString stringWithFormat:@"%@%@",bean.sortType,bean.title];
        CGSize size = [bean.desc sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:14.0f] forKey:NSFontAttributeName]];
        CGFloat width = self.view.frame.size.width-16;
        CGFloat line = size.width/width;
        line = [Common clcLine:line];
        contentLabel.frame=CGRectMake(8, 35, self.view.frame.size.width-16, size.height*line);
        contentLabel.text = bean.desc;
        otherLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",bean.author,bean.cdate,bean.reads,bean.comments];
        otherLabel.frame =CGRectMake(8, size.height*(line)+40, self.view.frame.size.width-16, 25);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    if(bean){
        CGSize size = [bean.desc sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:14.0f] forKey:NSFontAttributeName]];
        CGFloat width = self.view.frame.size.width-16;
        CGFloat line = size.width/width;
        CGFloat height =size.height*(line+1);
        return height+65;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    [ShareData shareInstance].blog = bean;
    [ShareData shareInstance].flag=NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    backItem.tintColor=[UIColor whiteColor];
    [self.navigationItem setBackBarButtonItem:backItem];
    WebController *show = [[WebController alloc] init];
    show.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:show animated:YES];
}


@end
