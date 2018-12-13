//
//  ViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//


#import "RootViewController.h"
#import "AssetsViewController.h"
#import "MineViewController.h"

#define kTagItem 100

@interface RootViewController ()<HTTPClientDelegate>
{
    NetWorkClient *_requestClient;
    BOOL _isMust;  //是否强制更新app
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏底部黑线
    [self.tabBar setClipsToBounds:YES];
    // 加载子视图控制器
    [self loadViewControllers];
    
}

- (void)loadViewControllers
{
    // 1 创建首页
    AssetsViewController *vc1 = [[AssetsViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc1];
    homeNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"资产" image:[UIImage imageNamed:@"icon_tab_normal_01"] selectedImage:[UIImage imageNamed:@"icon_tab_selected_01"]];
    homeNav.tabBarItem.tag = 100;
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_selected_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"icon_tab_normal_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:TEXT_GOLD_COLOR forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    // 2 创建账户页
    MineViewController *vc2 = [[MineViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:vc2];
    mineNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_tab_normal_02"] selectedImage:[UIImage imageNamed:@"icon_tab_selected_02"]];
    mineNav.tabBarItem.tag = 101;
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_selected_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"icon_tab_normal_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:TEXT_GOLD_COLOR forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    // 将子视图控制器放入数组
    NSArray *vcs = @[homeNav, mineNav];
    // 添加标签控制器
    [self setViewControllers:vcs animated:YES];

}
//#pragma  mark -- UITabBarDelegate
//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item
//{
//    if (Item.tag == 100) {
////        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateWalletPageView object:nil];
//    }
//}


@end
