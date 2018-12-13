//
//  SDFlowImageView.m
//  Qicai
//
//  Created by KAI on 15/7/13.
//  Copyright (c) 2015年 7ien. All rights reserved.
//

#import "SDFlowImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "SDImageCache.h"

@implementation SDFlowImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.exclusiveTouch = YES;
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGestureRecognize];
    }
    return self;
}

- (void)setFlowImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    _imageUrl = url;
    _placeholderImages = placeholder;
    
    UIImage *image = [SDFlowImageView imageWithURL:url];
    if ([image isKindOfClass:[UIImage class]]) {
        [self setImage:image];
    } else {
        [self setImage:placeholder];
    }
    
    if (!_isFlow) {
        [self setImageWithURL:_imageUrl placeholderImage:_placeholderImages];
    }
    
}

- (void)singleTapGestureRecognizer:(UIButton *)button {
    if (_isFlow) {
        [self setImageWithURL:_imageUrl placeholderImage:_placeholderImages];
        [self.superview sendSubviewToBack:self];
    }
}

- (void)startDownImage {
    [self setImageWithURL:_imageUrl placeholderImage:_placeholderImages];
    [self.superview sendSubviewToBack:self];
}

+ (BOOL)hasCacheWithURLStr:(NSString *)URLStr {
    return [SDFlowImageView hasCacheWithURL:[NSURL URLWithString:URLStr]];
}

+ (BOOL)hasCacheWithURL:(NSURL *)url {
    UIImage *image = [SDFlowImageView imageWithURL:url];
    return [image isKindOfClass:[UIImage class]];
}

+ (UIImage *)imageWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    return [[UIImageView sharedImageCache] cachedImageForRequest:request];
}

@end
