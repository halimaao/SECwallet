//
//  ViewController.h
//  CALScanQRCode
//
//  Created by Cain on 5/2/16.
//  Copyright © 2016 Cain. All rights reserved.
//

#import "CALScanQRCodeViewController.h"

@protocol ScanQRCodeViewControllerDelegate;

@interface ScanQRCodeViewController : CALScanQRCodeViewController

@property (nonatomic, weak)id<ScanQRCodeViewControllerDelegate> delegate;

@end

@protocol ScanQRCodeViewControllerDelegate <NSObject>

//返回事件
-(void)getScanCode:(NSString *)codeStr;

@end
