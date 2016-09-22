//
//  UIImage+QRcode.h
//  二维码生成
//
//  Created by baiqiang on 16/5/3.
//  Copyright © 2016年 白强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRcode)
/**
 *  二维码生成
 *
 *  @param content 二维码文本内容
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content;

/**
 *  高清二维码生成
 *
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size;
/**
 *  生成带标示的二维码
 *
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param logo    标示图片
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo;
/**
 *  带颜色的高清二维码
 *
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param red     红色值
 *  @param green   绿色值
 *  @param blue    蓝色值
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
/**
 *  带颜色标示符的高清二维码
 *
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param logo    标示图片
 *  @param red     红色值
 *  @param green   绿色值
 *  @param blue    蓝色值
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

@end
