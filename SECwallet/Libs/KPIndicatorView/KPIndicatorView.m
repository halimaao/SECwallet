//
//  KPIndicatorView.m
//  Code4AppDemo
//
//  Created by kunpo on 16/3/18.
//  Copyright © 2016年 Eric Wang. All rights reserved.
//

#import "KPIndicatorView.h"
#import "RoundView.h"

@interface KPIndicatorView ()

{
    float _numOfMoveView;
    NSArray *_arrayOfMoveView;
    UIColor *_colorOfMoveView;
    float _speed;
    float _moveViewSize;
    float _moveSize;
    float _w;
    float _r;
    
    NSTimer *_animateTimer;
}

@end


@implementation KPIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self settingDefault];
    }
    
    return self;
}

- (void)settingDefault
{
    _colorOfMoveView = [UIColor darkTextColor];
    _speed = 1;
    _numOfMoveView = 12;
    _moveViewSize = 1.5;
    _moveSize = 1.5;
    self.hidden = YES;
    [self initMoviews];
}


- (void)setIndicatorWith:(NSString *)image num:(int)num speed:(float)speed backGroundColor:(UIColor *)backColor color:(UIColor *)color moveViewSize:(float)moveViewSize moveSize:(float)moveSize
{
    if (image)
    {
        self.backImage.image = [UIImage imageNamed:image];
    }
    
    if (backColor) {
        self.backgroundColor = backColor;
    }
    _colorOfMoveView = [UIColor darkTextColor];
    if (color) {
        _colorOfMoveView = color;
    }
    _speed = 1.0;
    if (speed > 0) {
        _speed = speed;
    }
    _numOfMoveView = 12;
    if (num > _numOfMoveView) {
        _numOfMoveView = num;
    }
    _moveViewSize = 1;
    if ((moveViewSize > 0) && (moveViewSize <= 1)) {
        _moveViewSize = moveViewSize;
    }
    _moveSize = 1;
    if ((moveSize > 0) &&(moveSize <= 1))
    {
        _moveViewSize = moveSize;
    }
    
    self.hidden = YES;
    
    [self initMoviews];
}

- (void)initMoviews
{
    float r = self.frame.size.width;
    if (r > self.frame.size.height) {
        r = self.frame.size.height;
    }
    r = r / 2.0;
    r = r * _moveSize;
    float w = r * sin(2 * M_PI / _numOfMoveView) / 2.0;
    
    
    r -= (w / 2.0);
    w = w * _moveViewSize;
    _r = r;
    _w = w;
    NSMutableArray *arr = [NSMutableArray new];
    
    float alpha = 1.0;
    NSArray *colorArr = @[TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR,
                          TEXT_GOLD_COLOR];
    for (int i = 1; i < _numOfMoveView +1; i ++)
    {
        
        w = _w * i / _numOfMoveView;
        CGRect rect = CGRectMake(0 ,0 , w, w);
        
        RoundView *view = [[RoundView alloc] initWithFrame:rect];
        view.radian = (M_PI * 2.0 / _numOfMoveView) * i;
        CGPoint center = CGPointMake(self.frame.size.width / 2.0 + _r * cos(view.radian),_r * sin(view.radian) + self.frame.size.height / 2.0);
        view.center = center;
        view.viewColor = colorArr[i-1];
        view.backgroundColor = _colorOfMoveView;
        view.backgroundColor = [UIColor clearColor];
        view.alpha = alpha * (_numOfMoveView -1) / _numOfMoveView;
        [self addSubview:view];
        [arr addObject:view];
    }
    _arrayOfMoveView = [arr copy];
}


-(void)startAnimating
{
    if (_animateTimer) {
        return;
    }
       _animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 / ( _numOfMoveView * _speed) target:self selector:@selector(next) userInfo:nil repeats:YES];
    
    self.hidden = NO;
}

-(void)stopAnimating
{
    if (_animateTimer) {
        [_animateTimer invalidate];
        _animateTimer = nil;
        self.hidden = YES;
    }
}

- (void)next
{
        for (int i = 1; i < _numOfMoveView +1; i ++)
        {
            [UIView animateWithDuration:0.1/ (_numOfMoveView * _speed) animations:^{
                
                RoundView *view = _arrayOfMoveView[i - 1];
                view.radian +=  M_PI_2 / (2.0 *_numOfMoveView);
                CGPoint center = CGPointMake(self.frame.size.width / 2.0 + _r * cos(view.radian),self.frame.size.height / 2.0 + _r * sin(view.radian));
                view.center = center;
               
            }];
        }
}


@end


