//
//  KPIndicatorView.h
//  Code4AppDemo
//
//  Created by kunpo on 16/3/18.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPIndicatorView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

//- (void)settingDefault;

//* 背景图片，可以为空；小点的个数，最小为12否则无效；转动速度，大于0；背景颜色；小点的背景颜色；小点的大小，0-1;运动半径，0-1*/
- (void)setIndicatorWith:(NSString *)image num:(int)num speed:(float)speed backGroundColor:(UIColor *)backColor color:(UIColor *)color moveViewSize:(float)moveViewSize moveSize:(float)moveSize;
-(void)startAnimating;
-(void)stopAnimating;

@end
