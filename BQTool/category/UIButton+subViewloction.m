//
//  UIButton+subViewloction.m
//  tableViewTest
//
//  Created by MAC on 16/12/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "UIButton+subViewloction.h"

static const CGFloat spacing = 5;

@implementation UIButton (subViewloction)
- (void)adjustLabAndImageLocation:(BQBtnLocationType)type {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGFloat width = self.bounds.size.width;
    CGFloat imgX = self.imageView.frame.origin.x;
    CGFloat imgWidth = self.imageView.bounds.size.width;
    CGFloat labX = self.titleLabel.frame.origin.x;
    CGFloat labRight = CGRectGetMaxX(self.titleLabel.frame);
    if (BQBtnLocationType_center == type) {
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }else if (BQBtnLocationType_left == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -imgX, 0, imgX);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -(labX - spacing - imgWidth), 0, labX - spacing - imgWidth);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }else if (BQBtnLocationType_right == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, width - imgWidth - imgX, 0, imgX + imgWidth - width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, width - labRight - imgWidth - spacing , 0, labRight + imgWidth + spacing - width);
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }else if (BQBtnLocationType_imageTopLabBottom == type) {
        self.imageEdgeInsets = UIEdgeInsetsMake(spacing - self.imageView.frame.origin.y, width * 0.5 - self.imageView.center.x, self.imageView.frame.origin.y - spacing, self.imageView.center.x - width * 0.5);
        NSLog(@"%@",NSStringFromCGRect(self.imageView.frame));
        NSLog(@"前===== %@",NSStringFromCGRect(self.titleLabel.frame));
        self.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.imageView.frame) + 2 * spacing - self.titleLabel.frame.origin.y, width * 0.5 - self.titleLabel.center.x , self.titleLabel.frame.origin.y - 2 * spacing - CGRectGetMaxY(self.imageView.frame), self.titleLabel.center.x - width * 0.5);
        NSLog(@"后===== %@",NSStringFromCGRect(self.titleLabel.frame));
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
}
@end
