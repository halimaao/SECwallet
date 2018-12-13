//
//  SDFlowImageView.h
//  Qicai
//
//  Created by KAI on 15/7/13.
//  Copyright (c) 2015年 7ien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDFlowImageView : UIImageView {
    
    NSURL     *_imageUrl;
    UIImage   *_placeholderImages;
    BOOL       _isFlow;  //是否省流量
}

- (void)setFlowImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)startDownImage;

/** 判断某个链接是否已经下载完图片
 @param URLStr  图片string类型的url链接
 */
+ (BOOL)hasCacheWithURLStr:(NSString *)URLStr;

/** 判断某个链接是否已经下载完图片 
 @param url  图片url链接
 */
+ (BOOL)hasCacheWithURL:(NSURL *)url;

@end
