//
//  SettingsController.m
//  itog
//
//  Created by Shuwei on 15/10/19.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "SettingsController.h"

@interface SettingsController ()

@end

@implementation SettingsController{
    DBHelper *db;
    BOOL closeAutoBlog;
    BOOL closeAutoNews;
    BOOL closeAD;
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    db = [DBHelper sharedInstance];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.backgroundColor=[Common colorWithHexString:@"e0e0e0"];
    self.title=@"设置和支持";
    if([db openDB]){
        NSString *con =[ db getValueByKey:@"closeautoblog"];
        if(con&&[con isEqualToString:@"1"]){
            closeAutoBlog  = YES;
        }
        con =[ db getValueByKey:@"closeautonews"];
        if(con&&[con isEqualToString:@"1"]){
            closeAutoNews  = YES;
        }
        con =[ db getValueByKey:@"closeAD"];
        if(con&&[con isEqualToString:@"1"]){
            closeAD  = YES;
        }
        [self.tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(closeAD){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 2;
    }
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    view.backgroundColor=[Common colorWithHexString:@"e0e0e0"];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"cellIdentifier";
    UITableViewCell    *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.section==0){
        if(indexPath.row==0){
            UISwitch *swit = (UISwitch*)[cell viewWithTag:1];
            if(!swit){
                swit = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 6, 0, 0)];
                swit.tag=1;
                [swit addTarget:self action:@selector(switchFlag:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:swit];
            }
            swit.on=closeAutoBlog;
            cell.textLabel.text=@"关闭自动加载博客";
        }else if(indexPath.row==1){
            UISwitch *swit = (UISwitch*)[cell viewWithTag:2];
            if(!swit){
                swit = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 6, 0, 0)];
                swit.tag=2;
                [swit addTarget:self action:@selector(switchFlag:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:swit];
            }
            swit.on=closeAutoNews;
            cell.textLabel.text=@"关闭自动加载新闻";
        }
    }else if(indexPath.section==1){
        UISwitch *swit = (UISwitch*)[cell viewWithTag:3];
        if(!swit){
            swit = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 6, 0, 0)];
            swit.tag=3;
            [swit addTarget:self action:@selector(switchFlag:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:swit];
        }
        swit.on=NO;
        cell.textLabel.text=@"关闭广告并开启新闻资讯(6￥)";
    }
    return cell;
}
-(void)switchFlag:(id)sender  {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSString *ret = @"0";
    if (isButtonOn) {
        ret=@"1";
    }else {
        ret=@"0";
    }
    if(switchButton.tag==1){
        [db saveOrUpdateKeyValue:@"closeautoblog" andValue:ret];
    }else if(switchButton.tag==2){
        [db saveOrUpdateKeyValue:@"closeautonews" andValue:ret];
    }else if(switchButton.tag==3){
        [hud show:YES];
        [self requestPurchase];
    }
}
-(void)requestPurchase{
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.jov.itog.closeadAndOpen", nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    
    [IAPShare sharedHelper].iap.production = NO;
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            
                                            if(trans.error)
                                            {
                                                NSLog(@"Fail %@",[trans.error localizedDescription]);
                                                [hud hide:YES];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                
                                                [[IAPShare sharedHelper].iap checkReceipt:trans.transactionReceipt onCompletion:^(NSString *response, NSError *error) {
                                                    
                                                    //Convert JSON String to NSDictionary
                                                    NSDictionary* rec = [IAPShare toJSON:response];
                                                    
                                                    if([rec[@"status"] integerValue]==0)
                                                    {
                                                        NSString *productIdentifier = trans.payment.productIdentifier;
                                                        [[IAPShare sharedHelper].iap provideContent:productIdentifier];
                                                        NSLog(@"SUCCESS %@",response);
                                                        [db saveOrUpdateKeyValue:@"closeAD" andValue:@"1"];
                                                        NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                                        [hud hide:YES];
                                                    }
                                                    else {
                                                        NSLog(@"Fail");
                                                        [hud hide:YES];
                                                    }
                                                }];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                NSLog(@"Fail");
                                                [hud hide:YES];
                                            }
                                        }];//end of buy product
         }else{
             [hud hide:YES];
         }
     }];
}

@end
