//
//  InvestRecordManageViewController.m
//  Topzrt
//
//  Created by Laughing on 16/10/13.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "ImportWalletManageViewController.h"
#import "SGSegmentedControl.h"
#import "ImportWalletViewController.h"
#import "ScanQRCodeViewController.h"

#define kDefaultTabHeight Size(36)

@interface ImportWalletManageViewController ()<UIScrollViewDelegate, SGSegmentedControlDelegate,ScanQRCodeViewControllerDelegate>

@property (nonatomic, strong) SGSegmentedControl *SG;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation ImportWalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    [self setupSegmentedControl];
}

- (void)initNavigationBar
{
    self.title = @"导入钱包";
    
    [self.navigationController.navigationBar setBarTintColor:TEXT_GOLD_COLOR];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      BLACK_COLOR, NSForegroundColorAttributeName,
                                                                      BoldSystemFontOfSize(18), NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    backItem.tintColor = BLACK_COLOR;
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

- (void)setupSegmentedControl {
    
    NSArray *titleArr = @[@"助记词", @"官方钱包", @"私钥"];
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kDefaultTabHeight, kScreenWidth, kScreenHeight -kDefaultTabHeight -KNaviHeight)];
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth * titleArr.count, 0);
    _mainScrollView.backgroundColor = CLEAR_COLOR;
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultTabHeight) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:titleArr btn_Margin:15];
    _SG.segmentedControlIndicatorType = SGSegmentedControlIndicatorTypeBottom;
    _SG.titleColorStateSelected = COLOR(175, 136, 68, 1);
    _SG.indicatorColor = COLOR(175, 136, 68, 1);
    _SG.titleColorStateNormal = TEXT_DARK_COLOR;
    [self.view addSubview:_SG];
    //横线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Size(20), _SG.maxY -Size(3), kScreenWidth -Size(20)*2, Size(1))];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [self.view addSubview:line];
    
    ImportWalletViewController *controller1 = [[ImportWalletViewController alloc] init];
    controller1.importWalletType = ImportWalletType_mnemonicPhrase;
    [self addChildViewController:controller1];
    
}

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

// 添加所有子控制器
- (void)setupChildViewController {
    // 助记词
    ImportWalletViewController *controller1 = [[ImportWalletViewController alloc] init];
    controller1.importWalletType = ImportWalletType_mnemonicPhrase;
    [self addChildViewController:controller1];
    // 官方钱包
    ImportWalletViewController *controller2 = [[ImportWalletViewController alloc] init];
    controller2.importWalletType = ImportWalletType_keyStore;
    [self addChildViewController:controller2];
    // 私钥
    ImportWalletViewController *controller3 = [[ImportWalletViewController alloc] init];
    controller3.importWalletType = ImportWalletType_privateKey;
    [self addChildViewController:controller3];
    
}

// 显示控制器的view
- (void)showVc:(NSInteger)index
{
//    if (index == 1) {
//        //扫一扫
//        UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scanIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
//        scanItem.tag = 2;
//        [self.navigationItem setRightBarButtonItem:scanItem];
//    }else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    
    CGFloat offsetX = index * self.view.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, kScreenWidth, kScreenHeight -kDefaultTabHeight -KNaviHeight);
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 1.添加子控制器view
    [self showVc:index];
    // 2.把对应的标题选中
    [self.SG titleBtnSelectedWithScrollView:scrollView];
}

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case 2:
        {
            //扫一扫
            ScanQRCodeViewController *viewController = [[ScanQRCodeViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma ScanQRCodeViewControllerDelegate
-(void)getScanCode:(NSString *)codeStr
{
    
}

@end
