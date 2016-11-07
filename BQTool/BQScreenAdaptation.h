//
//  BQScreenAdaptation.h
//  runtimeDemo
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#ifndef BQScreenAdaptation_h
#define BQScreenAdaptation_h

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"
/**
    将IPHONE_WIDTH改为对应设计图的宽度
    在使用的时候直接使用BQAdaptationFrame函数
    还原为其设计图上的坐标位置，需要除以BQAdaptationWidth()
 */
#define IPHONE_WIDTH 375

FOUNDATION_STATIC_INLINE CGFloat BQAdaptationWidth() {
    return Screen_Widht / IPHONE_WIDTH;
}


FOUNDATION_STATIC_INLINE CGFloat BQAdaptation(CGFloat x) {
    return x * BQAdaptationWidth();
}
FOUNDATION_STATIC_INLINE CGSize BQadaptationSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return newSize;
}
FOUNDATION_STATIC_INLINE CGPoint BQadaptationPoint(CGFloat x, CGFloat y) {
    CGFloat newX = x * BQAdaptationWidth();
    CGFloat newY = y * BQAdaptationWidth();
    CGPoint point = CGPointMake(newX, newY);
    return point;
}

FOUNDATION_STATIC_INLINE CGRect BQAdaptationFrame(CGFloat x,CGFloat y, CGFloat width,CGFloat height)  {
    CGFloat newX = x * BQAdaptationWidth();
    CGFloat newY = y * BQAdaptationWidth();
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGRect rect = CGRectMake(newX, newY, newWidth, newHeight);
    return rect;
}
#endif /* BQScreenAdaptation_h */



@interface UIView (BQChangeFrameValue)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint thisCenter;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@end

@implementation UIView (BQChangeFrameValue)
- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}
- (void)setThisCenter:(CGPoint)thisCenter {
    
}
- (CGPoint)thisCenter {
    return CGPointMake(self.width * 0.5,self.height * 0.5);
}
- (CGPoint)origin{
    return self.frame.origin;
}
- (void)setLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x  = left;
    self.frame = rect;
}
- (CGFloat)left{
    return self.origin.x;
}
- (void)setTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y  = top;
    self.frame = rect;
}
- (CGFloat)top{
    return self.origin.y;
}
- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width  = width;
    self.frame = rect;
}
- (CGFloat)width {
    return self.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height {
    return self.size.height;
}
- (void)setBottom:(CGFloat)bottom{
    
}
- (void)setRight:(CGFloat)right{
    
}
- (CGFloat)right {
    return self.left + self.width;
}
- (CGFloat)bottom {
    return self.top + self.height;
}
@end

@interface CALayer (BQChangeFrameValue)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint thisCenter;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@end

@implementation CALayer (BQChangeFrameValue)
- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}
- (void)setThisCenter:(CGPoint)thisCenter {
    
}
- (CGPoint)thisCenter {
    return CGPointMake(self.width * 0.5,self.height * 0.5);
}
- (CGPoint)origin{
    return self.frame.origin;
}
- (void)setLeft:(CGFloat)left{
    CGRect rect = self.frame;
    rect.origin.x  = left;
    self.frame = rect;
}
- (CGFloat)left{
    return self.origin.x;
}
- (void)setTop:(CGFloat)top{
    CGRect rect = self.frame;
    rect.origin.y  = top;
    self.frame = rect;
}
- (CGFloat)top{
    return self.origin.y;
}
- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size{
    return self.frame.size;
}
- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width  = width;
    self.frame = rect;
}
- (CGFloat)width {
    return self.size.width;
}
- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height {
    return self.size.height;
}
- (void)setBottom:(CGFloat)bottom{
    
}
- (void)setRight:(CGFloat)right{
    
}
- (CGFloat)right {
    return self.left + self.width;
}
- (CGFloat)bottom {
    return self.top + self.height;
}
@end
