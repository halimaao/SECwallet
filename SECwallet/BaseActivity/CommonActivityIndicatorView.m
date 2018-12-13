//
//  CommonActivityIndicatorView.m
//  Huitai
//
//  Created by Laughing on 2017/6/9.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "CommonActivityIndicatorView.h"

@interface CommonActivityIndicatorView ()
{
    UIImageView *_actImageV;
}

@end

@implementation CommonActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self initContentView];
    }
    return self;
}

- (void)initContentView
{
    _actImageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 30)/2.f, 15, 30, 30)];
    [_actImageV setImage:[UIImage imageNamed:@"appindicator_circle"]];
    [self addSubview:_actImageV];

}

-(void)startAnimating
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [_actImageV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopAnimating
{
    [_actImageV.layer removeAllAnimations];
}

@end
