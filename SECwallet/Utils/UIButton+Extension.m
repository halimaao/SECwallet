//
//  UIButton+Extension.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

// 正常风格按钮
-(void)customerBtnStyle:(NSString *)title andBkgImg:(NSString *)bkgImg{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    [self setBackgroundImage:[UIImage imageNamed:bkgImg] forState:UIControlStateNormal];
}

//金色大按钮
-(void)goldBigBtnStyle:(NSString *)title{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"goldBigBtn"] forState:UIControlStateNormal];
}

// 金色小按钮
-(void)goldSmallBtnStyle:(NSString *)title{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor: WHITE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"goldSmallBtn"] forState:UIControlStateNormal];
}

// 金色大圆角小按钮
-(void)goldSmallBtnStyle1:(NSString *)title{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor: WHITE_COLOR forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"goldSmallBtn1"] forState:UIControlStateNormal];
}

// 灰色风格按钮
-(void)darkBtnStyle:(NSString *)title
{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    self.layer.cornerRadius = Size(5);
    [self setTitleColor:COLOR(184, 184, 184, 1) forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    self.backgroundColor = COLOR(227, 227, 227, 1);
     [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

// 灰色边框风格按钮
-(void)darkBorderBtnStyle:(NSString *)title{
    self.layer.borderWidth = Size(1);
    self.layer.cornerRadius = Size(23);
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:COLOR(195, 195, 195, 1) forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = SystemFontOfSize(18);
    self.backgroundColor = WHITE_COLOR;
    self.layer.borderColor = DARK_COLOR.CGColor;
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef mContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(mContext, [color CGColor]);
    CGContextFillRect(mContext, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
