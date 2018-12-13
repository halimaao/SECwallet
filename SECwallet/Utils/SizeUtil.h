//
//  SizeUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

//--- 跳转通知
#define NotificationUpdateTab                  @"update_tab"
#define NotificationUpdateWalletPageView       @"update_WalletPageView"      //通知切换钱包列表
#define NotificationUpdateWalletInfoUI           @"update_WalletInfoUI"      //通知更新钱包主页面

#define Size(x) ((x)*kScreenWidth/320.f)  //屏幕适配

#define SystemFontOfSize(x) ((IS_iPhone4 || IS_iPhone5) ? [UIFont systemFontOfSize:(x-2)] : [UIFont systemFontOfSize:x])  //正常字体  ArialRoundedMTBold
#define BoldSystemFontOfSize(x) ((IS_iPhone4 || IS_iPhone5) ? [UIFont boldSystemFontOfSize:(x-2)] : [UIFont boldSystemFontOfSize:x])  //加粗字体

#define IS_iPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)

#define KStatusBarHeight  (IS_iPhoneX ? 44.f : 20.f)
#define KNaviHeight       ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0 ? 44: (IS_iPhoneX ? 88 :64))
#define KTabbarHeight     (IS_iPhoneX ? (49.f+34.f) : 49.f)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

// =====================================================================
// 应用程序总代理
#define AppDelegateInstance	 ((AppDelegate*)([UIApplication sharedApplication].delegate))

// =====================================================================
// 操作系统是否大于等于iOS5
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)

// 操作系统是否大于等于iOS6
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

// 操作系统是否大于等于iOS7
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// 操作系统是否大于等于iOS8
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
// =====================================================================
// 判断是否是iOS 7系统
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)

// 判断是否是iOS 8系统
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)

// 操作系统是否大于等于iOS11
#define IS_IOS11  ([[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] != NSOrderedAscending)
//======================================================================

#define IS_iPhone4 [UIScreen mainScreen].bounds.size.height == 480

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define IS_iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

// 判断是否iPhone设备或者iPhone 模拟器
#define IS_IPHONE                                  ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])




@interface SizeUtil : NSObject

@end
