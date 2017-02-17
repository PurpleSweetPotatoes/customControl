//
//  BQImagePicker.h
//  NavgationBar-Test
//
//  Created by baiqiang on 16/10/17.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

//裁剪比例
typedef NS_ENUM(NSUInteger, ClipSizeType) {
    ClipSizeTypeNone,
    ClipSizeTypeOneScaleOne,//1:1
    ClipSizeTypeTwoScaleOne,//2:1
    ClipSizeTypeThreeScaleTwo//3:2
};

@interface BQImagePicker : NSObject

/**
 调用相册或相机选择图片，使用系统裁剪

 @param handle 回调方法
 */
+ (void)showPickerImageWithHandleImage:(void(^)(UIImage *image))handle;

/**
 调用相册或相机选择图片，使用自定义方式裁剪
 @param type   裁剪类型
 @param handle 回调方法
 */
+ (void)showPickerImageWithClipType:(ClipSizeType)type handleImage:(void(^)(UIImage *image))handle;
@end

@interface BQDisImageView : UIView

/**
 显示裁剪界面
 @param image    展示的图片
 @param type     裁剪类型
 @param callBack 回调方法
 */
+ (void)showClipViewWithImage:(UIImage *)image
                     clipSize:(ClipSizeType)type
                     callBack:(void(^)(UIImage *image))callBack;
@end
