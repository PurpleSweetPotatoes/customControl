//
//  UIImage+Zip.m
//  NavgationBar-Test
//
//  Created by baiqiang on 16/10/14.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "UIImage+Zip.h"

@implementation UIImage (Zip)


#pragma mark  -------- 压缩 --------
//压缩成宽高均为width的矩形
+(UIImage *)imageWithImage:(UIImage *)image aimWidth:(NSInteger)width{
    if (!image) {
        return nil;
    }
    UIImage * newImage = [self rectImageWithImage:image];
    if (width > 0 && newImage.size.width > width) {
        return [self imageWithImage:newImage scaledToSize:CGSizeMake(width, width)];
    }
    return newImage;
}

//指定压缩尺寸
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//剪切成方形image
+(UIImage *)rectImageWithImage:(UIImage *)image{
    CGImageRef  image_cg = [image CGImage];
    CGSize      imageSize = CGSizeMake(CGImageGetWidth(image_cg), CGImageGetHeight(image_cg));
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat width;
    CGPoint purePoint;
    if (imageWidth > imageHeight){
        width = imageHeight;
        purePoint = CGPointMake((imageWidth - width) / 2, 0);
    }else{
        width = imageWidth;
        purePoint = CGPointMake(0, (imageHeight - width) / 2);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(purePoint.x, purePoint.y, width, width));
    UIImage * thumbImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbImage;
    
}

#pragma mark  -------- 质量压缩 --------
/**
 *  质量不变，压缩到指定大小范围
 *  aimLength：目标大小      accurancyOfLength：压缩控制误差范围(+ / -)        maxCircleNum:最大循环次数
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum{
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    CGFloat scale = image.size.height/image.size.width;
    if (imageData.length <= length + accuracy) {
        return imageData;
    }else{
        //先对质量进行0.99的压缩，再压缩尺寸
        NSData * imgData = UIImageJPEGRepresentation(image, 0.99);
        if (imgData.length <= length + accuracy) {
            return imgData;
        }else{
            UIImage * img = [UIImage imageWithData:imgData];
            int flag = 0;
            NSInteger maxWidth = img.size.width;
            NSInteger minWidth = 50;
            NSInteger midWidth = (maxWidth + minWidth)/2;
            if (flag == 0) {
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(minWidth, minWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                if ([data length] > length + accuracy) {
                    return data;
                }
            }
            
            while (1) {
                flag ++ ;
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(midWidth, midWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                NSInteger imageLength = data.length;
                if (flag >= maxCircleNum) {
                    return data;
                }
                
                if (imageLength > length + accuracy) {
                    maxWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else if (imageLength < length - accuracy){
                    minWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else{
                    return data;
                }
            }
        }
    }
}

/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值）
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy{
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGSize  aimSize;
    if (width >= (imgWidth > imgHeight ? imgWidth : imgHeight)) {
        aimSize = image.size;
    }else{
        if (imgHeight > imgWidth) {
            aimSize = CGSizeMake(width*imgWidth/imgHeight, width);
        }else{
            aimSize = CGSizeMake(width, width*imgHeight/imgWidth);
        }
    }
    UIImage * newImage = [UIImage imageWithImage:image scaledToSize:aimSize];
    
    NSData  * data = UIImageJPEGRepresentation(newImage, 1);
    NSInteger imageDataLen = [data length];
    
    if (imageDataLen <= length + accuracy) {
        return data;
    }else{
        NSData * imageData = UIImageJPEGRepresentation( newImage, 0.99);
        if (imageData.length < length + accuracy) {
            return imageData;
        }
        
        
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            if (flag >= 6) {
                NSData * data = UIImageJPEGRepresentation(newImage, minQuality);
                return data;
            }
            flag ++;
            
            NSData * imageData = UIImageJPEGRepresentation(newImage, midQuality);
            NSInteger len = imageData.length;
            
            if (len > length+accuracy) {
                maxQuality = midQuality;
                continue;
            }else if (len < length-accuracy){
                minQuality = midQuality;
                continue;
            }else{
                return imageData;
                break;
            }
        }
    }
}

@end
