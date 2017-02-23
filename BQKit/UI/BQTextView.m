//
//  BQTextView.m
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQTextView.h"

@interface BQTextView ()
@property (nonatomic, strong) UILabel * placeHolderLabel;
@end

@implementation BQTextView
+ (instancetype)createTextViewWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    BQTextView * textView = [[BQTextView alloc] initWithFrame:frame];
    textView.placeholder = placeholder;
    textView.font = [UIFont systemFontOfSize:15];
    return textView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
- (void)initUI {
    UILabel * label = [[UILabel alloc] init];
    label.font = self.font;
    label.numberOfLines = 0;
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
    self.placeHolderLabel = label;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self changeLabelFrame];
}
- (void)changeLabelFrame {
    self.placeHolderLabel.text = self.placeholder;
    if (self.font) {
        self.placeHolderLabel.font = self.font;
    }
    CGFloat y = self.textContainerInset.top;
    CGFloat x = 5;
    CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(self.bounds.size.width - 2 * x, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.placeHolderLabel.font} context:nil].size;
    self.placeHolderLabel.frame = CGRectMake(x, y, size.width, size.height);
}
- (void)textDidChange {
    self.placeHolderLabel.hidden = self.hasText;
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self changeLabelFrame];
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    [self changeLabelFrame];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeHolderLabel.textColor = placeholderColor;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
