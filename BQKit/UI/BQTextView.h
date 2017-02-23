//
//  BQTextView.h
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQTextView : UITextView

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

+ (instancetype)createTextViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
@end
