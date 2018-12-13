//
//  LoadingView.m
//  PetrolBao
//
//  Created by mac on 13-5-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "LoadingView.h"

#if __has_feature(objc_arc)
    #define MB_RETAIN(exp) exp
#else
    #define MB_RETAIN(exp) [exp retain]
#endif

#define loadingWidth Size(80)
#define loadingheight Size(70)
@implementation LoadingView

@synthesize labelText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.labelText = @"加载中...";
    }
    return self;
}

- (void)showLoadingView:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated
{
    methodForExecution = method;
	targetForExecution = MB_RETAIN(target);
	objectForExecution = MB_RETAIN(object);
    [self initLabel];
    [NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
}

- (void)showLoadingViewOnly
{
    [self initLabel];
}

- (void)initLabel
{
    for (UIView *subVi in self.subviews) {
        [subVi removeFromSuperview];
    }
    [self.layer removeAllAnimations];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = BLACK_COLOR;
    backgroundView.alpha = 0.6f;
    [self addSubview:backgroundView];
    
    UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - loadingWidth)/2.0, (kScreenHeight - loadingheight)/2.0, loadingWidth, loadingheight)];
    labelView.backgroundColor = WHITE_COLOR;
    labelView.layer.cornerRadius = 10;
    [self addSubview:labelView];

    UIImageView *actImageV = [[UIImageView alloc] initWithFrame:CGRectMake((loadingWidth - Size(30))/2.f, (loadingheight - Size(30))/2.0-Size(10), Size(30), Size(30))];
    [actImageV setImage:[UIImage imageNamed:@"appindicator_circle"]];
    [labelView addSubview:actImageV];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = ULLONG_MAX;
    rotationAnimation.removedOnCompletion = NO;
    [actImageV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, actImageV.maxY, loadingWidth, Size(30))];
    lab.font = SystemFontOfSize(12);
    lab.textColor = TEXT_BLACK_COLOR;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.labelText;
    [labelView addSubview:lab];
    
}

- (void)launchExecution
{
	@autoreleasepool {
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
        //[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
		//[self performSelectorOnMainThread:methodForExecution withObject:nil waitUntilDone:NO];
        //[targetForExecution performSelectorOnMainThread:methodForExecution withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp
{
    targetForExecution = nil;
	objectForExecution = nil;
}

@end
