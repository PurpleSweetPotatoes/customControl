//
//  UIButton+subViewloction.h
//  tableViewTest
//
//  Created by MAC on 16/12/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BQBtnLocationType) {
    BQBtnLocationType_center,
    BQBtnLocationType_left,
    BQBtnLocationType_right,
    BQBtnLocationType_imageTopLabBottom,
};

@interface UIButton (subViewloction)
- (void)adjustLabAndImageLocation:(BQBtnLocationType)type;
@end
