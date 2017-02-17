//
//  UIImage+QRcode.m
//  二维码生成
//
//  Created by baiqiang on 16/5/3.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "UIImage+QRcode.h"

@implementation UIImage (QRcode)
+ (UIImage *)createCodeImageWithContent:(NSString *)content {
    UIImage *image = [UIImage imageWithCIImage:[self createCodeCIImageWithContent:content]];
    return image;
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size {
    
    CIImage *image = [self createCodeCIImageWithContent:content];
    //获得生成的二维码坐标信息
    CGRect extent = CGRectIntegral(image.extent);
    //获得缩放比例
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //颜色灰度配置
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //创建绘图上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    //创建图像上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //在图像上下文中创建图片并设置大小
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    //设置插值质量,不设置线性插值 清晰度更高
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    //对上下文大小进行缩放
    CGContextScaleCTM(bitmapRef, scale, scale);
    //对上下文进行图像绘制
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //释放创建的对象
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    //转换成uiimage
    //6.返回生成好的二维码
    return [UIImage imageWithCGImage:scaledImage];
}
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo {
    UIImage *image = [self createCodeImageWithContent:content size:size];
    return [image addlogo:logo];
}
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [UIImage createCodeImageWithContent:content size:size];
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
//        else
//        {
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
//        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [self createCodeImageWithContent:content size:size red:red green:green blue:blue];
    return [image addlogo:logo];
}

+ (CIImage *)createCodeCIImageWithContent:(NSString *)content {
    //1.实例化滤镜
    CIFilter *filder = [CIFilter filterWithName:@"CIQRCodeGenerator"];//名字不能错
    //2.恢复滤镜默认属性（有可能会保存上一次的属性）
    [filder setDefaults];
    //3.将我们的字符串转换成DSData
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    //4.通过KVO设置滤镜，传入data，将来滤镜就知道要传入的数据生成二维码
    [filder setValue:data forKey:@"inputMessage"];//名字不能错，固定
    [filder setValue:@"H" forKey:@"inputCorrectionLevel"];
    //5.生成二维码
    CIImage *outputImage = [filder outputImage];
    
    return outputImage;
}

- (UIImage *)addlogo:(UIImage *)logo {
    // 添加logo
    CGFloat logoW = self.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
@end
