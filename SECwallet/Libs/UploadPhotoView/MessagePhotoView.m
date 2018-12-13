//
//  ZBShareMenuView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码网站: Code4App.com

#import "MessagePhotoView.h"
#import "ZYQAssetPickerController.h"

// 每行有4个
#define kZBMessageShareMenuPerRowItemCount 4
#define kZBMessageShareMenuPerColum 2

#define kZBShareMenuItemIconSize 60
#define KZBShareMenuItemHeight 80

#define MaxItemCount 4
#define ItemWidth Size(60)

@interface MessagePhotoView ()

/**
 *  这是背景滚动视图
 */
@property(nonatomic,strong) UIScrollView *photoScrollView;
@property(nonatomic,weak)UIButton *btnviewphoto;
@property(nonatomic,strong)NSMutableArray *array;
@property (nonatomic) UIImagePickerController *imagePickerController;
@end

@implementation MessagePhotoView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _flag = 1;
        _array = [NSMutableArray array];
        [self setup];
    }
    return self;
}



- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];

    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Size(300), Size(80))];
    _photoScrollView.contentSize = CGSizeMake(1024, 80);
   
    photoMenuItems = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    [self addSubview:_photoScrollView];
    
    [self initlizerScrollView:self.photoMenuItems];

}

-(void)reloadDataWithImage:(UIImage *)image
{
    [self.photoMenuItems addObject:image];
    [self initlizerScrollView:self.photoMenuItems];
}


-(void)initlizerScrollView:(NSArray *)imgList
{
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<imgList.count;i++){
        UIImage *tempImg;
        tempImg = imgList[i];
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(Size(10) +i* (ItemWidth +Size(10)), (ItemWidth -Size(80))/2, ItemWidth, ItemWidth)];
        photoItem.delegate = self;
        photoItem.index = i;
        photoItem.contentImage = tempImg;
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
    }
    NSInteger picCount;
    if (_pictureCount == 10) {
        picCount = 9;
    } else if (_pictureCount == 1){
        picCount = 1;
    } else {
        picCount = MaxItemCount;
    }
    if(imgList.count<picCount){
        UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake( Size(10) + (ItemWidth +Size(10)) *imgList.count, Size(12), ItemWidth, ItemWidth)];//
        [btnphoto setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
        [btnphoto setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateSelected];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:btnphoto];
    }
    
    NSInteger count = MIN(imgList.count +1, picCount);
    [self.photoScrollView setContentSize:CGSizeMake(Size(10) +(ItemWidth + Size(10))*count, 0)];
    
}

-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    [myActionSheet showInView:self.window];
    
}

//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
            break;
        default:
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){

        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.imagePickerController = picker;
    [self.delegate addUIImagePicker:self.imagePickerController];
}

//打开相册，可以多选
-(void)localPhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = 1;  //禁止多选
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 1;
        }else{
            return  YES;
        }
    }];
    
    [self.delegate addPicker:picker];
}


/*
 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    _flag = 1;
   
    [_array removeAllObjects];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < assets.count; i++) {
        
        UIImage *tempImg;
        ALAsset *asset=assets[i];
        tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        //图片压缩
        CGSize imagesize = tempImg.size;
        imagesize.height = imagesize.width > 320 ? imagesize.height * (320 / imagesize.width) : imagesize.height;
        imagesize.width = imagesize.width > 320 ? 320 : imagesize.width;
        tempImg = [self imageWithImage:tempImg scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(tempImg,0.00001);
        tempImg = [UIImage imageWithData:imageData];

        NSString *_encodedImageStr = [UIImageJPEGRepresentation(tempImg,0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];;

        NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_encodedImageStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
        [_array addObject:tempImg];
        [arr addObject:baseString];
    }
    if (_array.count == 0) {
        UIAlertView *ak = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ak show];
        return;
    }
  
    if (self.didSelectedArray != nil) {
        self.didSelectedArray(arr);
    }

    [self reloadDataWithImage:_array[0]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
  
}
/////////////////////////////////////////////////////////

//压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _flag = 2;
    //关闭相册界面
    UIImage *type = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:type withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
        
    NSString *_encodedImageStr = [UIImageJPEGRepresentation(savedImage,0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];;
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_encodedImageStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    [self reloadDataWithImage:savedImage];
        
    if (self.didSelectedPicture != nil) {
        self.didSelectedPicture(baseString);
    }
    
    baseString = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadData
{
    [self initlizerScrollView:self.photoMenuItems];
}

//- (void)dealloc
//{
//    self.photoScrollView.delegate = self;
//    self.imagePickerController  = nil;
//}

#pragma mark - MessagePhotoItemDelegate

-(void)messagePhotoItemView:(MessagePhotoMenuItem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index
{
    [self.photoMenuItems removeObjectAtIndex:index];
    [self initlizerScrollView:self.photoMenuItems];
    if (self.didDeleteIndex != nil) {
        self.didDeleteIndex(index);
    }
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
