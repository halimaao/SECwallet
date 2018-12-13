//
//  BaseViewController.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "BaseViewController.h"

#define HUDYOFFSET   kScreenHeight/Size(3.3)

@interface BaseViewController ()<HTTPClientDelegate,MBProgressHUDDelegate>
{
    UIImageView *navigationImageView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = WHITE_COLOR;
    self.navigationController.navigationBar.tintColor = BLACK_COLOR;
    
    //设置返回back
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    navigationImageView.hidden = YES;
    
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = WHITE_COLOR;
    self.navigationController.navigationBar.tintColor = BLACK_COLOR;
    
    //设置返回back
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

-(void)backAction
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 适配iOS11
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

#pragma mark HTTPClientDelegate 网络数据回调代理
-(void) startRequest
{
    _isLoading = YES;
    [self createLoadingView:@"正在加载"];
}

// 返回成功
-(void) httpResponseSuccess:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didSuccessWithObject:(id)obj
{
    _isLoading  = NO;
    [HUD hide:YES];
    NSDictionary *dics = obj;
    NSNumber *result_type = [dics objectForKey:@"status"];
    
    if ([result_type intValue] == 1) {
        //返回成功
        
    }else {
        // 错误返回码
        NSString *msg = [dics objectForKey:@"msg"];
        NSLog(@"%@", msg);
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_ok"]];
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD hide:YES afterDelay:1]; // 延时2s消失
        HUD.labelText = msg;
    }
}

// 返回失败
-(void) httpResponseFailure:(NetWorkClient *)client dataTask:(NSURLSessionDataTask *)task didFailWithError:(NSError *)error
{
    [self hudShowWithString:@"通信超时，请重试" delayTime:1];
    _isLoading  = NO;
    [HUD hide:YES];
}

// 无可用的网络
-(void) networkError
{
    [self createHUD:MBProgressHUDModeText withMessage:@"网络繁忙" withDetailMessage:@"请检查您的网络设置" withDuration:1.5 withCompletionBlock:nil];
    _isLoading  = NO;
    [HUD hide:YES];
}

/** 显示提示信息 */
- (void)hudShowWithString:(NSString *)str delayTime:(CGFloat)time{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelFont = SystemFontOfSize(15);
    HUD.cornerRadius = Size(17.5);
    HUD.color = BLACK_COLOR;
    HUD.margin = Size(10);
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = str;
    HUD.yOffset = HUDYOFFSET;
    [HUD hide:YES afterDelay:time];
}

#pragma mark -- 设置label标题栏
- (void)setNavgationItemTitle:(NSString *)string
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Size(60), Size(36))];
    label.textColor = BLACK_COLOR;
    label.textAlignment = 1;
    label.text = string;
    label.font = BoldSystemFontOfSize(18);
    self.navigationItem.titleView = label;
}

#pragma mark -- 设置导航栏左边文字
- (void)setNavgationLeftTitle:(NSString *)item withAction:(SEL)methot
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:item
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:methot];
    leftItem.tintColor = BLACK_COLOR;
    [leftItem setTitleTextAttributes:@{NSFontAttributeName:SystemFontOfSize(16)} forState:0];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


#pragma mark -- 设置导航栏左边按钮图片
- (void)setNavgationLeftImage:(UIImage *)image withAction:(SEL)methot
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:methot];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

#pragma mark -- 设置导航栏右边按钮文字
- (void)setNavgationRightTitle:(NSString *)item withAction:(SEL)methot
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:item
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:methot];
    rightItem.tintColor = BLACK_COLOR;
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:SystemFontOfSize(16)} forState:0];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- 设置导航栏右边按钮图片
- (void)setNavgationRightImage:(UIImage *)image withAction:(SEL)methot
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:methot];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

}

#pragma mark 显示请求数据的HUD，不执行方法
- (void)createLoadingView:(NSString *)message
{
    if (_loadingView) {
        [_loadingView removeFromSuperview];
    }
    _loadingView = [[LoadingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _loadingView.labelText = message==nil ?@"加载中...":message;
    [_loadingView showLoadingViewOnly];
    [AppDelegateInstance.window addSubview:_loadingView];
}

#pragma mark  隐藏请求数据的HUD
- (void)hiddenLoadingView
{
    _isLoading  = NO;
    [HUD hide:YES];
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark 创建HUD
- (void)createHUD:(MBProgressHUDMode)mode withMessage:(NSString *)message withDetailMessage:(NSString *)msg withDuration:(float)duration withCompletionBlock:(void(^)(void))completionBlock
{
    HUD = [[MBProgressHUD alloc] init];
    HUD.dimBackground = NO;
    HUD.margin = Size(10);
    HUD.cornerRadius = Size(17.5f);
    HUD.mode = mode;
    HUD.color = BLACK_COLOR;
    HUD.labelText = message;
    HUD.detailsLabelText = msg;
    HUD.detailsLabelFont = SystemFontOfSize(15);
    HUD.labelFont = SystemFontOfSize(15);
    HUD.yOffset = HUDYOFFSET;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(duration);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (completionBlock) {
            completionBlock();
        }
    }];
}
- (void)createOffsetHUD:(MBProgressHUDMode)mode withMessage:(NSString *)message withDetailMessage:(NSString *)msg withDuration:(float)duration offsetY:(float)offsetY withCompletionBlock:(void(^)(void))completionBlock
{
    HUD = [[MBProgressHUD alloc] init];
    HUD.dimBackground = NO;
    HUD.margin = Size(10);
    HUD.cornerRadius = Size(17.5f);
    HUD.mode = mode;
    HUD.color = BLACK_COLOR;
    HUD.labelText = message;
    HUD.detailsLabelText = msg;
    HUD.detailsLabelFont = SystemFontOfSize(15);
    HUD.labelFont = SystemFontOfSize(15);
    HUD.yOffset = offsetY;
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(duration);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (completionBlock) {
            completionBlock();
        }
    }];
}
@end
