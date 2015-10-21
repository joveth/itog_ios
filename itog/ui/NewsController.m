//
//  NewsController.m
//  itog
//
//  Created by Shuwei on 15/10/19.
//  Copyright © 2015年 jov. All rights reserved.
//

#import "NewsController.h"

@interface NewsController ()

@end

@implementation NewsController{
    NSArray *tabTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    tabTitles = [NSArray arrayWithObjects:@"csdn业界",@"cnblogs新闻",@"oschina资讯",@"iteye资讯",@"cnbeta资讯",@"36kr资讯",@"虎嗅资讯",@"i黑马文章",@"cocoachina",nil];
    //huxiu http://www.huxiu.com/v2_action/article_list page
    //36kr http://36kr.com/?b_url_code=5038569&d=next
    self.title=[tabTitles objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return [tabTitles count];
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = [tabTitles objectAtIndex:index];
    [label sizeToFit];
    label.textColor=[UIColor whiteColor];
    return label;
}
#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    UIViewController *cvc = [[UIViewController alloc] init];
    switch (index) {
        case 0:
            cvc = [[CSDNNewsController alloc] init];
            break;
        case 1:{
            cvc = [[CNBNewsController alloc] init];
            break;
        }
        case 2:{
            cvc = [[OSCNewsController alloc] init];
            break;
        }
        case 3:{
            cvc = [[ITEYENewsController alloc] init];
            break;
        }
        case 4:{
            cvc = [[CNBETANewsController alloc] init];
            break;
        }
        case 5:{
            cvc = [[Kr36Controller alloc] init];
            break;
        }
        case 6:{
            cvc = [[HUXIUController alloc] init];
            break;
        }
        case 7:{
            cvc = [[IHEIMAController alloc] init];
            break;
        }
        case 8:{
            cvc = [[CocoachinaController alloc] init];
            break;
        }
        default:
            break;
    }
    return cvc;
}
#pragma mark - ViewPagerDelegate
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerTabsView:
            return FlatRed;
        default:
            return FlatWhite;
    }
}
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.title=[tabTitles objectAtIndex:index];
}
@end
