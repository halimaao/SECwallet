//
//  LoadingView.h
//  PetrolBao
//
//  Created by mac on 13-5-16.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingView : UIView
{
    SEL methodForExecution;
    id targetForExecution;
	id objectForExecution;
}

@property (strong, nonatomic) NSString *labelText;
@property (strong, nonatomic) UIImageView *actImageView;

- (void)launchExecution;
- (void)showLoadingViewOnly;
- (void)showLoadingView:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

@end
