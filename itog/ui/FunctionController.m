//
//  FunctionController.m
//  itog
//
//  Created by Shuwei on 15/10/15.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "FunctionController.h"

@interface FunctionController ()

@end

@implementation FunctionController{
    UIImageView *image;
    UIView *content;
    UIView *other;
    DBHelper *db;
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    self.view.backgroundColor=[Common colorWithHexString:@"e0e0e0"];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, 130)];
    image.tag=1;
    [self.view addSubview:image];
    content = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 180)];
    content.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:content];
    other= [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 44)];
    other.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:other];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    singleTap.cancelsTouchesInView=NO;
    singleTap.delegate = self;
    [image addGestureRecognizer:singleTap];
    CGFloat width = self.view.frame.size.width/3;
    
    UIView *b0 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, width-5, 85)];
    UIImageView *i0 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i0.image = [UIImage imageNamed:@"news"];
    i0.layer.cornerRadius=25;
    i0.layer.masksToBounds=YES;
    UILabel *l0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l0.font=[UIFont systemFontOfSize:14];
    l0.textColor=[UIColor flatBlackColor];
    l0.textAlignment=NSTextAlignmentCenter;
    l0.text=@"新闻资讯";
    [b0 addSubview:i0];
    [b0 addSubview:l0];
    b0.tag=2;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap0.cancelsTouchesInView=NO;
    tap0.delegate = self;
    [b0 addGestureRecognizer:tap0];
    [content addSubview:b0];
    
    UIView *b1 = [[UIView alloc] initWithFrame:CGRectMake(width, 5, width-5, 85)];
    UIImageView *i1 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i1.image = [UIImage imageNamed:@"added"];
    i1.layer.cornerRadius=25;
    i1.layer.masksToBounds=YES;
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l1.font=[UIFont systemFontOfSize:14];
    l1.textColor=[UIColor flatBlackColor];
    l1.textAlignment=NSTextAlignmentCenter;
    l1.text=@"叠式浏览";
    [b1 addSubview:i1];
    [b1 addSubview:l1];
    b1.tag=3;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap1.cancelsTouchesInView=NO;
    tap1.delegate = self;
    [b1 addGestureRecognizer:tap1];
    [content addSubview:b1];
    
    UIView *b2 = [[UIView alloc] initWithFrame:CGRectMake(width*2, 5, width-5, 85)];
    UIImageView *i2 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i2.image = [UIImage imageNamed:@"search"];
    i2.layer.cornerRadius=25;
    i2.layer.masksToBounds=YES;
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l2.font=[UIFont systemFontOfSize:14];
    l2.textColor=[UIColor flatBlackColor];
    l2.textAlignment=NSTextAlignmentCenter;
    l2.text=@"搜索博客";
    [b2 addSubview:i2];
    [b2 addSubview:l2];
    b2.tag=4;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap2.cancelsTouchesInView=NO;
    tap2.delegate = self;
    [b2 addGestureRecognizer:tap2];
    [content addSubview:b2];
    
    UIView *b3 = [[UIView alloc] initWithFrame:CGRectMake(5, 95, width-5, 85)];
    UIImageView *i3 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i3.image = [UIImage imageNamed:@"iteye"];
    UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l3.font=[UIFont systemFontOfSize:14];
    l3.textColor=[UIColor flatBlackColor];
    l3.textAlignment=NSTextAlignmentCenter;
    l3.text=@"ITeye";
    [b3 addSubview:i3];
    [b3 addSubview:l3];
    b3.tag=5;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap3.cancelsTouchesInView=NO;
    tap3.delegate = self;
    [b3 addGestureRecognizer:tap3];
    [content addSubview:b3];
    
    UIView *b4 = [[UIView alloc] initWithFrame:CGRectMake(width, 95, width-5, 85)];
    UIImageView *i4 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i4.image = [UIImage imageNamed:@"person"];
    UILabel *l4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l4.font=[UIFont systemFontOfSize:14];
    l4.textColor=[UIColor flatBlackColor];
    l4.textAlignment=NSTextAlignmentCenter;
    l4.text=@"不错的站点";
    [b4 addSubview:i4];
    [b4 addSubview:l4];
    b4.tag=6;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap4.cancelsTouchesInView=NO;
    tap4.delegate = self;
    [b4 addGestureRecognizer:tap4];
    [content addSubview:b4];
    
    UIView *b5 = [[UIView alloc] initWithFrame:CGRectMake(width*2, 95, width-5, 85)];
    UIImageView *i5 = [[UIImageView alloc] initWithFrame:CGRectMake( (width-55)/2, 5, 50, 50)];
    i5.image = [UIImage imageNamed:@"fav"];
    UILabel *l5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, width-5, 20)];
    l5.font=[UIFont systemFontOfSize:14];
    l5.textColor=[UIColor flatBlackColor];
    l5.textAlignment=NSTextAlignmentCenter;
    l5.text=@"我的收藏";
    [b5 addSubview:i5];
    [b5 addSubview:l5];
    b5.tag=7;
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap5.cancelsTouchesInView=NO;
    tap5.delegate = self;
    [b5 addGestureRecognizer:tap5];
    [content addSubview:b5];
    NSString *temp=@"设置和支持" ;
    CGSize size=[temp sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
    CGFloat x = width - size.width- 30;
    UIView *other0 = [[UIView alloc] initWithFrame:CGRectMake(5, 2, width-5, 40)];
    UIImageView *otherimage0 = [[UIImageView alloc] initWithFrame:CGRectMake(x/2, 10, 20, 20)];
    otherimage0.image = [UIImage imageNamed:@"help"];
    UILabel *otherlabel0 = [[UILabel alloc] initWithFrame:CGRectMake(x/2+25, 10, size.width+5, 20)];
    otherlabel0.font=[UIFont systemFontOfSize:12];
    otherlabel0.textColor=[UIColor flatBlackColor];
    
    otherlabel0.text=temp;//userContentWrapper,
    [other0 addSubview:otherimage0];
    [other0 addSubview:otherlabel0];
    other0.tag=8;
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap8.cancelsTouchesInView=NO;
    tap8.delegate = self;
    [other0 addGestureRecognizer:tap8];
    [other addSubview:other0];
    temp = @"关于应用";
    size =[temp sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
    x = width - size.width- 30;
    UIView *other1 = [[UIView alloc] initWithFrame:CGRectMake(width, 2, width-5, 40)];
    UIImageView *otherimage1 = [[UIImageView alloc] initWithFrame:CGRectMake(x/2, 10, 20, 20)];
    otherimage1.image = [UIImage imageNamed:@"about"];
    UILabel *otherlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(x/2+25, 10, size.width+5, 20)];
    otherlabel1.font=[UIFont systemFontOfSize:12];
    otherlabel1.textColor=[UIColor flatBlackColor];
    //otherlabel1.textAlignment=NSTextAlignmentCenter;
    otherlabel1.text=@"关于应用";//userContentWrapper,
    [other1 addSubview:otherimage1];
    [other1 addSubview:otherlabel1];
    other1.tag=9;
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap9.cancelsTouchesInView=NO;
    tap9.delegate = self;
    [other1 addGestureRecognizer:tap9];
    [other addSubview:other1];
    temp = @"可以留言";
    size =[temp sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:12.0f] forKey:NSFontAttributeName]];
    x = width - size.width- 30;
    UIView *other2 = [[UIView alloc] initWithFrame:CGRectMake(width*2, 2, width-5, 40)];
    UIImageView *otherimage2 = [[UIImageView alloc] initWithFrame:CGRectMake(x/2, 10, 20, 20)];
    otherimage2.image = [UIImage imageNamed:@"message"];
    UILabel *otherlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(x/2+25, 10, size.width+5, 20)];
    otherlabel2.font=[UIFont systemFontOfSize:12];
    otherlabel2.textColor=[UIColor flatBlackColor];
    //otherlabel2.textAlignment=NSTextAlignmentCenter;
    otherlabel2.text=@"可以留言";//userContentWrapper,
    [other2 addSubview:otherimage2];
    [other2 addSubview:otherlabel2];
    other2.tag=10;
    UITapGestureRecognizer *tap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handler:)];
    tap10.cancelsTouchesInView=NO;
    tap10.delegate = self;
    [other2 addGestureRecognizer:tap10];
    [other addSubview:other2];
    db = [DBHelper sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10){
        if(buttonIndex==1){
            [self requestPurchase];
        }
    }
}
-(void)handler :(UITapGestureRecognizer *)sender{
    NSLog(@"tag=%ld",sender.view.tag);
    if(sender.view.tag==1){
        int x = arc4random() % 10;
        NSString *name = [NSString stringWithFormat:@"o%d.jpg",x];
        [image setImage:[UIImage imageNamed:name]];
    }else {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        backItem.tintColor=[UIColor whiteColor];
        [self.navigationItem setBackBarButtonItem:backItem];
        
        switch (sender.view.tag) {
            case 2:{
                
                if([db openDB]){
                    NSString *con =[ db getValueByKey:@"closeAD"];
                    if(con&&[con isEqualToString:@"1"]){
                        NewsController *show = [[NewsController alloc] init];
                        show.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:show animated:YES];
                    }else{
                        [Common showMessageWithCancelAndOkButton:@"对不起，您还没有开通该功能，是否现在开通？" andTag:10 andDelegate:self ];
                    }
                }
                break;
            }
            case 3:{
                //[self requestPurchase];
                AllController *show = [[AllController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 4:{
                SearchController *show = [[SearchController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 5:{
                
                ITEYEController *show = [[ITEYEController alloc] init];
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 6:{
                WebSiteController *show = [[WebSiteController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 7:{
                FavoriteController *show = [[FavoriteController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 8:{
                SettingsController *show = [[SettingsController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 9:{
                AboutController *show = [[AboutController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            case 10:{
                MessageViewController *show = [[MessageViewController alloc] init];
                show.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:show animated:YES];
                break;
            }
            default:
                break;
        }
        
    }
}
-(void)requestPurchase{
    [hud show:YES];
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
                                                [Common showMessageWithOkButton:[NSString stringWithFormat:@"处理失败了，返回：%@,如果你确认已购买，请务必与我联系。",[trans.error localizedDescription]]];
                                                
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
                                                        [Common showMessageWithOkButton:[NSString stringWithFormat:@"处理失败了，返回：status=1,如果你确认已购买，请务必与我联系。"]];
                                                        [hud hide:YES];
                                                    }
                                                }];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                NSLog(@"Fail");
                                                [Common showMessageWithOkButton:[NSString stringWithFormat:@"处理失败了，返回：Transaction was cancelled or failed before being added to the server queue,如果你确认已购买，请务必与我联系。"]];
                                                [hud hide:YES];
                                            }
                                        }];//end of buy product
         }else{
             [hud hide:YES];
         }
     }];
}

@end
