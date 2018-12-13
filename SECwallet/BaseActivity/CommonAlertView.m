//
//  CommonAlertView.m
//  Topzrt
//
//  Created by Laughing on 16/6/30.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import "CommonAlertView.h"

#define kAlertWidth     Size(270)

//标题，内容，左按钮，右按钮
#define kAlertHeight_style1    Size(170)

//图片、标题，内容，按钮
#define kAlertHeight_style2    Size(190)

//标题，图片，内容，按钮
#define kAlertHeight_style3    Size(180)

#define kImageHeight       Size(125)

#define kTitleHeight       Size(25)

#define kContentHeight     Size(50)

#define kButtonWidth       Size(130)
#define kButtonHeight      Size(38)

@interface CommonAlertView ()
{
    float _alertViewHeight;
    BOOL _leftLeave;
    
    int _alertViewType;      //视图类型
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertMsgLabel;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic,assign) CommonAlertViewType alertType;
@end

@implementation CommonAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
          imageName:(NSString *)imageName
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      alertViewType:(CommonAlertViewType)alertViewType
{
    if (self = [super init]) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = WHITE_COLOR;
        self.alertType = alertViewType;
        //叉号
        UIButton *deleteBT = [[UIButton alloc]initWithFrame:CGRectMake(kAlertWidth -Size(15 +15), Size(15), Size(15), Size(15))];
        [deleteBT setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        deleteBT.adjustsImageWhenHighlighted = NO;
        [deleteBT addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBT];
        
        _alertViewType = alertViewType;
        
        if (alertViewType == CommonAlertViewType_style1) {
            //标题，内容，左按钮，右按钮
            CGSize size = [content calculateSize:SystemFontOfSize(14) maxWidth:kAlertWidth -Size(20)];
            
            _alertViewHeight = kTitleHeight +Size(10) +size.height +size.height/Size(15) *Size(5) +Size(35) +kButtonHeight;
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(16);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            _alertTitleLabel.textColor = TEXT_BLACK_COLOR;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //虚线
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, _alertTitleLabel.maxY, kAlertWidth, Size(0.8))];
            line.image = [UIImage imageNamed:@"alert_dottedLine"];
            [self addSubview:line];
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(10), line.maxY +Size(10), kAlertWidth -Size(20), size.height +size.height/Size(15) *Size(5))];
            msgLb.font = SystemFontOfSize(14);
            msgLb.textColor = TEXT_BLACK_COLOR;
            msgLb.numberOfLines = 100;
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(5);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            
            if (rigthTitle.length == 0) {
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -kButtonWidth)/2, _alertViewHeight -kButtonHeight -Size(15), kButtonWidth, kButtonHeight)];
                [_leftBtn goldSmallBtnStyle:leftTitle];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                
            }else{
                int insert = (kAlertWidth/2 -kButtonWidth)/2;
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(insert, _alertViewHeight -kButtonHeight -Size(15), kButtonWidth, kButtonHeight)];
                [_leftBtn goldSmallBtnStyle:leftTitle];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                
                _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kAlertWidth/2 +insert, _leftBtn.minY, kButtonWidth, kButtonHeight)];
                [_rightBtn goldSmallBtnStyle:leftTitle];
                [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_rightBtn];
            }
        }else if (alertViewType == CommonAlertViewType_style2) {
            //图片、标题，内容，按钮
            _alertViewHeight = kAlertHeight_style2;
            //图片
            UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake((kAlertWidth -Size(42))/2, Size(10), Size(42), Size(42))];
            imageIV.image = [UIImage imageNamed:imageName];
            [self addSubview:imageIV];
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageIV.maxY, kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = SystemFontOfSize(18);
            _alertTitleLabel.textColor = TEXT_BLACK_COLOR;
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //内容
            content = @"如果有人获取你的助记词将直接获取你的资产，请抄下助记词并放在安全的地方。";
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(10), _alertTitleLabel.maxY, kAlertWidth -Size(10), kContentHeight)];
            msgLb.font = SystemFontOfSize(14);
            msgLb.textColor = TEXT_DARK_COLOR;
            msgLb.numberOfLines = 2;
            msgLb.text = content;
            [self addSubview:msgLb];
            //设置行间距
            NSMutableAttributedString *msgStr = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = Size(3);
            [msgStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msgStr.length)];
            msgLb.attributedText = msgStr;
            
            if (rigthTitle.length == 0) {
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake((kAlertWidth -kButtonWidth)/2, kAlertHeight_style2 -kButtonHeight -Size(15), kButtonWidth, kButtonHeight)];
                [_leftBtn goldSmallBtnStyle:leftTitle];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                
            }else{
                int insert = (kAlertWidth/2 -kButtonWidth)/2;
                _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(insert, kAlertHeight_style2 -kButtonHeight -Size(10), kButtonWidth, kButtonHeight)];
                [_leftBtn goldSmallBtnStyle:leftTitle];
                [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftBtn];
                
                _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kAlertWidth/2 +insert, _leftBtn.minY, kButtonWidth, kButtonHeight)];
                [_rightBtn goldSmallBtnStyle:leftTitle];
                [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_rightBtn];
            }
        }else if (alertViewType == CommonAlertViewType_style3) {
            //标题，图片，内容，按钮
            _alertViewHeight = kAlertHeight_style3;
            
            _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Size(10), kAlertWidth, kTitleHeight)];
            _alertTitleLabel.font = BoldSystemFontOfSize(18);
            _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
            _alertTitleLabel.textColor = TEXT_BLACK_COLOR;
            [self addSubview:_alertTitleLabel];
            _alertTitleLabel.text = title;
            //图片
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(Size(30), _alertTitleLabel.maxY +Size(10), kAlertWidth -Size(30 *2), Size(35))];
            img.image = [UIImage imageNamed:imageName];
//            [self addSubview:img];
            //背景
            UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(img.minX, img.minY, img.width, img.height)];
            tipView.backgroundColor = COLOR(240, 118, 118, 1);
            tipView.layer.cornerRadius = Size(12);
            tipView.layer.borderWidth = Size(1);
            tipView.layer.borderColor = COLOR(244, 24, 24, 1).CGColor;
            [self addSubview:tipView];
            UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(5), Size(3), tipView.width -Size(10), tipView.height -Size(6))];
            tipLb.textColor = WHITE_COLOR;
            tipLb.font = SystemFontOfSize(11);
            tipLb.numberOfLines = 2;
            tipLb.text = @"安全警告：私钥未经加密，导出存在风险，建议使用助记词和Keystore进行备份。";
            [tipView addSubview:tipLb];
            
            //背景
            UIView *bkgView = [[UIView alloc]initWithFrame:CGRectMake(img.minX, img.maxY +Size(5), img.width, Size(35))];
            bkgView.backgroundColor = COLOR(210, 210, 210, 1);
            bkgView.layer.cornerRadius = Size(5);
            [self addSubview:bkgView];
            //内容
            UILabel *msgLb = [[UILabel alloc] initWithFrame:CGRectMake(Size(10), Size(2), img.width -Size(10 *2), Size(30))];
            msgLb.font = SystemFontOfSize(10);
            msgLb.textColor = TEXT_BLACK_COLOR;
            msgLb.numberOfLines = 2;
            msgLb.text = content;
            [bkgView addSubview:msgLb];
            
            _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(img.minX, _alertViewHeight -kButtonHeight -Size(15), img.width, kButtonHeight)];
            [_leftBtn goldSmallBtnStyle:leftTitle];
            [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_leftBtn];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dismissAlert];

}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dismissAlert];
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth)/2, (CGRectGetHeight(topVC.view.bounds) - _alertViewHeight)/2, kAlertWidth, _alertViewHeight);
    [topVC.view addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3f;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [_backView removeFromSuperview];
    _backView = nil;
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3f;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        _backView.backgroundColor = BLACK_COLOR;
        _backView.alpha = 0.6f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:_backView];

    self.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];

    [super willMoveToSuperview:newSuperview];
}

@end

