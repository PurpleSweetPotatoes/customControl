//
//  BQTextView.m
//  Test
//
//  Created by MAC on 16/12/29.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import "BQTextView.h"

@interface BQTextView ()
@property (nonatomic, strong) UILabel * placeHolderLab;

@end

@implementation BQTextView

+ (instancetype)createWithFrame:(CGRect)frame placeholder:(NSString *)placeholderStr {
    return [[self alloc] initWithFrame:frame placeholder:placeholderStr];
}
- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholderStr {
    BQTextView * textView = [[BQTextView alloc] initWithFrame:frame];
    textView.placeholder = placeholderStr;
    return textView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.placeHolderLab];
        self.delegate = self;
        self.font = [UIFont systemFontOfSize:17];
    }
    return self;
}
- (void)changeLabFrame {
    if (self.placeholder.length > 0) {
        CGRect rect = [self.placeholder boundingRectWithSize:CGSizeMake(self.bounds.size.width - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
        self.placeHolderLab.frame = CGRectMake(5, 7, rect.size.width, rect.size.height);
    }
    self.placeHolderLab.text = self.placeholder;
}
#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLab.hidden = textView.text.length != 0;
}
#pragma mark - Set Method
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHolderLab.font = font;
    [self changeLabFrame];
}
- (void)setPlaceholder:(NSString *)placeholder {
    if (![_placeholder isEqualToString:placeholder]) {
        _placeholder = [placeholder copy];
        [self changeLabFrame];
    }
}
#pragma mark - Get Method
- (UILabel *)placeHolderLab {
    if (_placeHolderLab == nil) {
        UILabel * lab = [[UILabel alloc] init];
        lab.textColor = [UIColor lightGrayColor];
        lab.numberOfLines = 0;
        _placeHolderLab = lab;
    }
    return _placeHolderLab;
}
@end
