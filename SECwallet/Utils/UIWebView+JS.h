//
//  UIWebView+JS.h
//  汇银
//
//  Created by 李小斌 on 14-12-2.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JS)

-(void) loadHTMLString:(NSString *)content;

-(void) loadHTMLStringWhitoutWrap:(NSString *)content;

@end
