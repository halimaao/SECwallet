//
//  CommonHtmlJumpViewController.h
//  Huitai
//
//  Created by Laughing on 2017/6/17.
//  Copyright © 2017年 AnrenLionel. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    CommonHtmlShowViewType_startRgsProtocol =  0,            /**启动页协议*/
    CommonHtmlShowViewType_RgsProtocol =       1,            /**用户协议*/
    CommonHtmlShowViewType_other       =       2,            /**其他*/
    
} CommonHtmlShowViewType;

@interface CommonHtmlShowViewController : BaseViewController

@property (nonatomic, assign) CommonHtmlShowViewType commonHtmlShowViewType;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *adUrl;

@property (nonatomic, assign) BOOL isNoBack;

@end
