//
//  UIView+Category.m
//  TOP_zrt
//
//  Created by Laughing on 16/5/20.
//  Copyright © 2016年 topzrt. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (CGFloat)getMinY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)getMidY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)getMaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)getMinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)getMidX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)getMaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)getWidth {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)getHeight {
    return CGRectGetHeight(self.frame);
}

@end
