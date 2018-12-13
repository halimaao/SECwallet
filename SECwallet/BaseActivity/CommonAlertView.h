//
//  CommonAlertView.h
//  Topzrt
//
//  Created by Laughing on 16/6/30.
//  Copyright © 2016年 AnrenLionel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CommonAlertViewType_style1    = 0,         //标题，内容，左按钮，右按钮
    CommonAlertViewType_style2    = 1,         //图片、标题，内容，按钮
    CommonAlertViewType_style3    = 2,         //标题，图片，内容，按钮
} CommonAlertViewType;

@interface CommonAlertView : UIView


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
          imageName:(NSString *)imageName
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
      alertViewType:(CommonAlertViewType)alertViewType;


- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;


@end
