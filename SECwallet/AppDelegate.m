//
//  AppDelegate.m
//  Topzrt
//
//  Created by apple01 on 16/5/26.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import "RootViewController.h"
#include <objc/runtime.h>

@interface AppDelegate ()
{
    NSString *quitTime;   //退出进入后台时间戳
    NSString *enterTime;  //进入页面时间戳
    NSInteger count;
}

@property(strong, nonatomic)NSTimer *mTimer;
@property(assign, nonatomic)UIBackgroundTaskIdentifier backIden;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 开启网络监测程序
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = WHITE_COLOR;
    
    self.guideView = [[GuideViewController alloc] init];
    self.window.rootViewController = self.guideView;
    [self.window makeKeyAndVisible];
    
    //Bugly sdk嵌入
    [Bugly startWithAppId:kBuglyAppId];
    
    // 启动图片延时: 2秒
    [NSThread sleepForTimeInterval:2];
    
//    count=0;
    
    return YES;
}

//应用程序已经进入后台运行
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //记录退出后台时间
    quitTime = [NSString timestampChange:[NSDate date]];
    //添加毛玻璃效果
    if (IS_OS_8_OR_LATER) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = AppDelegateInstance.window.frame;
        effectView.alpha = 0.95;
        [AppDelegateInstance.window addSubview:effectView];
    }else{
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:AppDelegateInstance.window.frame];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.alpha = 0.95;
        [AppDelegateInstance.window addSubview:toolbar];
    }
    
    count=0;
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_mTimer forMode:NSRunLoopCommonModes];
    [self beginTask];
}

//应用程序将要进入活动状态执行
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //记录进入app时间
    enterTime = [NSString timestampChange:[NSDate date]];
    //判断时间差(进入后台时间超过180秒)
    if ([enterTime longLongValue] - [quitTime longLongValue] > 180) {  //180
    }
    //除去毛玻璃效果
    for (UIView *view in AppDelegateInstance.window.subviews) {
        if (IS_OS_8_OR_LATER) {
            if ([view isKindOfClass:[UIVisualEffectView class]]) {
                [view removeFromSuperview];
            }
        }else{
            if ([view isKindOfClass:[UIToolbar class]]) {
                [view removeFromSuperview];
            }
        }
    }
    [self endBack];
}
//计时
-(void)countAction{
    NSLog(@"%li",count++);
    //后台运行180秒
    if (count > 60) {
        [self endBack];
    }
}
//申请后台
-(void)beginTask
{
    NSLog(@"begin=============");
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block，一般是iOS7及以上是3分钟。按照规范，在这里要手动结束后台，你不写也是会结束的（据说会crash）
        NSLog(@"将要挂起=============");
        [self endBack];
    }];
}
//注销后台
-(void)endBack
{
    NSLog(@"end=============");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
    [_mTimer invalidate];
    _mTimer = nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"source app-%@, des app-%@",sourceApplication,application);
//    if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
//        return [UMSocialSnsService handleOpenURL:url];
//    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
//        return [UMSocialSnsService handleOpenURL:url];
//    }
    return YES;
    
}


@end
