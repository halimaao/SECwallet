//
//  ZBShareMenuView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码网站: Code4App.com

#import <UIKit/UIKit.h>
#import "MessagePhotoMenuItem.h"
#import "ZYQAssetPickerController.h"
#import "ShowBigViewController.h"

#define kZBMessageShareMenuPageControlHeight 30

typedef void(^DidSelectedPicture)(NSString *image);

typedef void(^DidSelectedArray)(NSArray *arrayImage);

typedef void(^DidDeliteIndex)(NSInteger index);

@protocol MessagePhotoViewDelegate <NSObject>


@optional
- (void)didSelectePhotoMenuItem:(MessagePhotoMenuItem *)shareMenuItem atIndex:(NSInteger)index;

-(void)addPicker:(ZYQAssetPickerController *)picker;

-(void)addUIImagePicker:(UIImagePickerController *)picker;

@end

@interface MessagePhotoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MessagePhotoItemDelegate,ZYQAssetPickerControllerDelegate>{
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
}
@property(nonatomic,strong) UIScrollView *scrollview;

@property(nonatomic,assign) NSInteger pictureCount;

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSMutableArray *photoMenuItems;

@property(nonatomic,strong) NSMutableArray *itemArray;

@property(nonatomic,assign) NSInteger flag;

@property (nonatomic, weak) id <MessagePhotoViewDelegate> delegate;

/**
 *  从相机选择照片，只有一张
 */
@property (nonatomic, copy) DidSelectedPicture didSelectedPicture;

/**
 *  从相册选择照片，可以多张
 */
@property (nonatomic, copy) DidSelectedArray didSelectedArray;

//删除图片
@property (nonatomic, copy) DidDeliteIndex didDeleteIndex;

-(void)reloadDataWithImage:(UIImage *)image;

- (void)reloadData;

//-(void)showTempImageByImageArrUrl:(NSArray *)imageArrUrl;


@end
