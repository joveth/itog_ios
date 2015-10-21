//
//  CSDNNewsController.m
//  itog
//
//  Created by Shuwei on 15/10/16.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "CSDNNewsController.h"

@interface CSDNNewsController ()

@end

@implementation CSDNNewsController{
    NSMutableArray *list;
    NSInteger pageno;
    DBHelper *db;
    NSInteger type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    list = [[NSMutableArray alloc] init];
    self.tableView.header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self load];
    }];
    
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self more];
    }];
    type = 6;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload"] style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    rightItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =rightItem;
    db = [DBHelper sharedInstance];
    if([db openDB]){
        NSString *con =[ db getValueByKey:@"closeautonews"];
        if(con&&[con isEqualToString:@"1"]){
        }else{
            [self.tableView.header beginRefreshing];
        }
    }
}
-(void)refresh{
    [self.tableView.header beginRefreshing];
}
-(void)load{
    pageno=1;
    [MainService getBlogs:pageno andType:type andSuccess:^(NSMutableArray *result) {
        if(result){
            [list removeAllObjects];
            [list addObjectsFromArray:result];
            [self.tableView reloadData];
        }
        if([list count]==0){
            [Common showMessageWithOkButton:@"加载失败了，请稍后再试！"];
        }
        [self.tableView.header endRefreshing];
    } andError:^(NSInteger code) {
        [Common showMessageWithOkButton:@"加载失败了，请稍后再试！"];
        [self.tableView.header endRefreshing];
    }];
}
-(void)more{
    pageno++;
    [MainService getBlogs:pageno andType:type andSuccess:^(NSMutableArray *result) {
        if(result&&[result count]>0){
            [list addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            pageno--;
        }
        [self.tableView.footer endRefreshing];
    } andError:^(NSInteger code) {
        [self.tableView.footer endRefreshing];
    }];
    
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
    UIImageView *image = (UIImageView*)[cell viewWithTag:4];
    
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
    if(image==nil){
        image = [[UIImageView alloc] initWithFrame:CGRectMake(8, 35, 50, 50)];
        image.tag=4;
        [cell addSubview:image];
    }
    
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    if(bean){
        nameLabel.text =[NSString stringWithFormat:@"%@%@",bean.sortType,bean.title];
        CGSize size = [bean.desc sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:14.0f] forKey:NSFontAttributeName]];
        CGFloat width = self.view.frame.size.width-71;
        CGFloat height = 0;
        CGFloat line=0;
        if(bean.image){
            image.hidden=NO;
            NSData *img = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:bean.image] ];
            image.image = [UIImage imageWithData:img];
            line = size.width/width;
            line = [Common clcLine:line];
            contentLabel.frame=CGRectMake(63, 35, width, size.height*line);
            contentLabel.text = bean.desc;
            height=size.height*(line);
            if(height<50){
                height = 90;
            }else{
                CGFloat y=height-50;
                y=y/2;
                height +=40;
                image.frame=CGRectMake(8, 35+y, 50, 50);
            }
        }else{
            image.hidden=YES;
            image.image=nil;
            width = self.view.frame.size.width-16;
            line = size.width/width;
            line = [Common clcLine:line];
            contentLabel.frame=CGRectMake(8, 35, width, size.height*line);
            contentLabel.text = bean.desc;
            height=size.height*(line)+40;
        }
        otherLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",bean.author,bean.cdate,bean.reads,bean.comments];
        otherLabel.frame =CGRectMake(8, height, self.view.frame.size.width-16, 25);
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    if(bean){
        CGSize size = [bean.desc sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:14.0f] forKey:NSFontAttributeName]];
        CGFloat width = self.view.frame.size.width-71;
        CGFloat line = size.width/width;
        CGFloat height =size.height*line;
        if(bean.image){
            if(height<50){
                height = 90;
            }else{
                height=size.height*(line+1);
            }
        }else{
            width = self.view.frame.size.width-16;
            line = size.width/width;
            height=size.height*(line+1);
        }
        return height+65;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogBean *bean = [list objectAtIndex:indexPath.row];
    bean.type=type;
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
