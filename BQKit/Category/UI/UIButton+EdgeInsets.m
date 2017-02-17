//
//  UIButton+EdgeInsets.m
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "UIButton+EdgeInsets.h"
#import "BQScreenAdaptation.h"

static const CGFloat spacing = 5;

@implementation UIButton (EdgeInsets)
- (void)adjustLabAndImageLocation:(BtnEdgeType)type {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGFloat width = self.bounds.size.width;
    CGFloat imgX = self.imageView.frame.origin.x;
    CGFloat imgWidth = self.imageView.bounds.size.width;
    CGFloat labX = self.titleLabel.frame.origin.x;
    CGFloat labRight = CGRectGetMaxX(self.titleLabel.frame);
    if (BtnEdgeType_center == type) {
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }else if (BtnEdgeType_left == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -imgX, 0, imgX);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(labX - spacing - imgWidth), 0, labX - spacing - imgWidth);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }else if (BtnEdgeType_right == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, width - imgWidth - imgX, 0, imgX + imgWidth - width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, width - labRight - imgWidth - spacing , 0, labRight + imgWidth + spacing - width);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }else if (BtnEdgeType_imageTopLabBottom == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(spacing - self.imageView.frame.origin.y, width * 0.5 - self.imageView.center.x, self.imageView.frame.origin.y - spacing, self.imageView.center.x - width * 0.5);
        self.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.imageView.frame) + 2 * spacing - self.titleLabel.frame.origin.y, - self.titleLabel.frame.origin.x , self.titleLabel.frame.origin.y - 2 * spacing - CGRectGetMaxY(self.imageView.frame), width - self.titleLabel.right);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
}
@end
