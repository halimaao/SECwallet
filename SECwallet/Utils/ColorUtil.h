//
//  ColorUtil.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置RGB颜色值
#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

// app 灰背景色
#define BACKGROUND_DARK_COLOR    COLOR(230,230,230,1)

//app导航栏背景色
#define Navi_COLOR	COLOR(52,152,219,1)

//app标签栏背景色
#define Tabbar_COLOR  [UIColor whiteColor]

//无色
#define CLEAR_COLOR	[UIColor clearColor]

// 白色
#define WHITE_COLOR	[UIColor whiteColor]

// 黑色
#define BLACK_COLOR	[UIColor blackColor]

// 灰色
#define DARK_COLOR	  COLOR(233,233,233,1)

/***********************字体***********************/
// 字体黑色
#define TEXT_BLACK_COLOR   COLOR(51,51,51,1)

// 字体灰色
#define TEXT_DARK_COLOR	   COLOR(178,178,178,1)

//字体金色
#define TEXT_GOLD_COLOR    COLOR(175, 136, 68, 1)

// 分割线颜色
#define DIVIDE_LINE_COLOR  COLOR(219, 219, 219, 1)



@interface ColorUtil : NSObject
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color color
 *
 *  @return UIColor
 */
+ (UIColor *) myToolsColorWithHexString: (NSString *)color;

@end

