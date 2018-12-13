//
//  UIButton+Extension.h
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

// 正常风格按钮
-(void)customerBtnStyle:(NSString *)title andBkgImg:(NSString *)bkgImg;

//金色大按钮
-(void)goldBigBtnStyle:(NSString *)title;

// 金色小按钮
-(void)goldSmallBtnStyle:(NSString *)title;

// 金色大圆角小按钮
-(void)goldSmallBtnStyle1:(NSString *)title;

// 灰色风格按钮
-(void)darkBtnStyle:(NSString *)title;

// 灰色边框风格按钮
-(void)darkBorderBtnStyle:(NSString *)title;

@end
