//
//  SelectEntryViewController.m
//  CEC_wallet
//
//  Created by 通证控股 on 2018/8/10.
//  Copyright © 2018年 AnrenLionel. All rights reserved.
//

#import "SelectEntryViewController.h"
#import "CreatWalletViewController.h"
#import "ImportWalletManageViewController.h"

@interface SelectEntryViewController ()

@end

@implementation SelectEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)initSubViews
{
    
    UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(20), Size(30), kScreenWidth, Size(35))];
    if (IS_iPhoneX) {
        nameLb.frame = CGRectMake(Size(20), Size(60), kScreenWidth, Size(35));
    }
    nameLb.font = SystemFontOfSize(35);
    nameLb.textColor = COLOR(189, 146, 83, 1);
    nameLb.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [self.view addSubview:nameLb];
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(nameLb.minX, nameLb.maxY, kScreenWidth, Size(25))];
    tipLb.font = SystemFontOfSize(16);
    tipLb.textColor = TEXT_DARK_COLOR;
    tipLb.text = @"最简单安全的智能数字钱包";
    [self.view addSubview:tipLb];
    /*****************导入钱包*****************/
    CGFloat padddingLeft = Size(20);
    UIButton *creatBT = [[UIButton alloc] initWithFrame:CGRectMake(padddingLeft, tipLb.maxY +Size(25), kScreenWidth - 2*padddingLeft, Size(175))];
    creatBT.layer.cornerRadius = Size(5);
    creatBT.layer.borderWidth = Size(1);
    creatBT.layer.borderColor = COLOR(189, 146, 83, 1).CGColor;
    [creatBT addTarget:self action:@selector(creatAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:creatBT];
    UILabel *creatLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(10), Size(15), Size(100), Size(20))];
    creatLb.font = SystemFontOfSize(26);
    creatLb.textColor = COLOR(104, 104, 104, 1);
    creatLb.text = @"创建钱包";
    [creatBT addSubview:creatLb];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:creatLb.text];
    [attStr addAttribute:NSFontAttributeName value:SystemFontOfSize(20) range:NSMakeRange(2, 2)];
    creatLb.attributedText = attStr;
    UILabel *des1Lb = [[UILabel alloc]initWithFrame:CGRectMake(creatLb.minX, creatLb.maxY +Size(10), Size(120), Size(30))];
    des1Lb.font = SystemFontOfSize(12.5);
    des1Lb.textColor = COLOR(187, 186, 186, 1);
    des1Lb.text = @"创建一个新的ETH钱包，\n支持所有ERC-20资产";
    des1Lb.numberOfLines = 2;
    [creatBT addSubview:des1Lb];
    //设置行间距
    NSMutableAttributedString *des1Str = [[NSMutableAttributedString alloc] initWithString:des1Lb.text];
    NSMutableParagraphStyle * des1LbparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    des1LbparagraphStyle.lineSpacing = Size(3);
    [des1Str addAttribute:NSParagraphStyleAttributeName value:des1LbparagraphStyle range:NSMakeRange(0, des1Str.length)];
    des1Lb.attributedText = des1Str;
    UIImageView *creatIV = [[UIImageView alloc]initWithFrame:CGRectMake(creatBT.width -Size(150 +10), Size(20), Size(150), Size(140))];
    creatIV.image = [UIImage imageNamed:@"start_creat"];
    [creatBT addSubview:creatIV];
    
    UIButton *importBT = [[UIButton alloc] initWithFrame:CGRectMake(creatBT.minX, creatBT.maxY +Size(35), creatBT.width, creatBT.height)];
    importBT.layer.cornerRadius = Size(5);
    importBT.layer.borderWidth = Size(1);
    importBT.layer.borderColor = COLOR(189, 146, 83, 1).CGColor;
    [importBT addTarget:self action:@selector(importAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:importBT];
    UILabel *importLb = [[UILabel alloc]initWithFrame:CGRectMake(Size(10), Size(15), Size(100), Size(20))];
    importLb.font = SystemFontOfSize(26);
    importLb.textColor = COLOR(104, 104, 104, 1);
    importLb.text = @"导入钱包";
    [importBT addSubview:importLb];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc]initWithString:importLb.text];
    [attStr1 addAttribute:NSFontAttributeName value:SystemFontOfSize(20) range:NSMakeRange(2, 2)];
    importLb.attributedText = attStr1;
    UILabel *des2Lb = [[UILabel alloc]initWithFrame:CGRectMake(importLb.minX, importLb.maxY +Size(10), Size(120), Size(30))];
    des2Lb.font = SystemFontOfSize(12.5);
    des2Lb.textColor = COLOR(187, 186, 186, 1);
    des2Lb.text = @"导入已有的ETH钱包，\n支持所有ERC-20资产";
    des2Lb.numberOfLines = 2;
    [importBT addSubview:des2Lb];
    //设置行间距
    NSMutableAttributedString *des2Str = [[NSMutableAttributedString alloc] initWithString:des2Lb.text];
    NSMutableParagraphStyle * des2LbparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    des2LbparagraphStyle.lineSpacing = Size(3);
    [des2Str addAttribute:NSParagraphStyleAttributeName value:des2LbparagraphStyle range:NSMakeRange(0, des2Str.length)];
    des2Lb.attributedText = des2Str;
    UIImageView *importIV = [[UIImageView alloc]initWithFrame:CGRectMake(creatIV.minX, Size(20), creatIV.width, creatIV.height)];
    importIV.image = [UIImage imageNamed:@"start_import"];
    [importBT addSubview:importIV];
    
}

#pragma mark 创建钱包
-(void)creatAction
{
    CreatWalletViewController *viewController = [[CreatWalletViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark 导入钱包
-(void)importAction
{
    ImportWalletManageViewController *viewController = [[ImportWalletManageViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
