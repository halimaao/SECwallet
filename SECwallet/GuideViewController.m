//
//  GuideViewController.m
//  Topzrt
//
//  Created by Laughing on 16/9/7.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "GuideViewController.h"
#import "RootViewController.h"
#import "CommonHtmlShowViewController.h"

#define Count 4

#define Insert Size(25)

@interface GuideViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray *imageArray;
    UIButton *enterBtn;
    
}

@property (nonatomic,strong) UIPageControl *control;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic, strong) RootViewController *tabBarController;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startRootViewWithoutAdView];
}

- (void)startRootViewWithoutAdView
{
    if ([AppDefaultUtil sharedInstance].hasCreatWallet == YES) {
        // 1 创建标签控制器
        self.tabBarController = [[RootViewController alloc] init];
        // 2 作为根视图控制器
        AppDelegateInstance.window.rootViewController = self.tabBarController;
        [AppDelegateInstance.window makeKeyAndVisible];
    }else{
        CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
        viewController.titleStr = @"商户协议";
        viewController.commonHtmlShowViewType = CommonHtmlShowViewType_startRgsProtocol;
        viewController.isNoBack = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
        AppDelegateInstance.window.rootViewController = navi;
        [AppDelegateInstance.window makeKeyAndVisible];
    }
}

//当程序第一次启动开启引导界面
-(void)addGuideView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(Count * kScreenWidth, kScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < Count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"guide_page%d" ,i+1];
        UIImage *image = [UIImage imageNamed: imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:imageView];
        
        if (i == Count-1) {
            UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*kScreenWidth+(kScreenWidth/2-Size(138)/2), kScreenHeight-Size(120), Size(138), Size(40))];
            [clickBtn setBackgroundColor:CLEAR_COLOR];
            [clickBtn addTarget:self action:@selector(gotoHomeView) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:clickBtn];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
        _control.currentPage = pageNum;
    }
}

#pragma mark 进入首页
- (void)gotoHomeView
{
    if ([AppDefaultUtil sharedInstance].hasCreatWallet == YES) {
        // 第一次登录应该直接进入主界面
        [[AppDefaultUtil sharedInstance] setFirstLancher:YES];
        // 1 创建标签控制器
        self.tabBarController = [[RootViewController alloc] init];
        // 2 作为根视图控制器
        AppDelegateInstance.window.rootViewController = self.tabBarController;
        [AppDelegateInstance.window makeKeyAndVisible];
        
        [UIView animateWithDuration:3 animations:^{
            _scrollView.alpha = 1;
        } completion:^(BOOL finished) {
            _scrollView.alpha = 0.0;
        }];
        
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
    }else{
        CommonHtmlShowViewController *viewController = [[CommonHtmlShowViewController alloc]init];
        viewController.isNoBack = YES;
        viewController.commonHtmlShowViewType = CommonHtmlShowViewType_startRgsProtocol;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
        AppDelegateInstance.window.rootViewController = navi;
        [AppDelegateInstance.window makeKeyAndVisible];
    }
}

@end
