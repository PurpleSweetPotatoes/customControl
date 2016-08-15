//
//  BQTextView.m
//  TextFeildTest
//
//  Created by baiqiang on 16/8/13.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "BQTextFieldView.h"

static NSTimeInterval DurationLabel = 0.25;
static NSTimeInterval DurationLayer = 0.3;

@interface BQTextFieldView ()<UITextFieldDelegate>
{
    BOOL _isShowTitle;
}
/**  主题色 */
@property (nonatomic, strong) UIColor * mainColor;
/**  下划线颜色 */
@property (nonatomic, strong) UIColor * bottomColor;
/**  label */
@property (nonatomic, strong) UILabel * label;
/**  layer */
@property (nonatomic, strong) UIView * lineView;
@end

@implementation BQTextFieldView

- (instancetype)initWithFrame:(CGRect)frame mainColor:(UIColor *)color title:(NSString *)title hodler:(NSString *)hodler {
    BQTextFieldView * textFieldView = [[BQTextFieldView alloc] initWithFrame:frame mainColor:color];
    textFieldView.title = title;
    textFieldView.hodler = hodler;
    return textFieldView;
}
- (instancetype)initWithFrame:(CGRect)frame mainColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainColor = color;
        _isShowTitle = NO;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.bottomColor = [UIColor colorWithWhite:0.859 alpha:1.000];
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.bounds.size.height * 0.5, self.bounds.size.width, self.bounds.size.height * 0.5)];
    CAShapeLayer * bottomLineLayer = [CAShapeLayer layer];
    bottomLineLayer.backgroundColor = self.bottomColor.CGColor;
    bottomLineLayer.frame = CGRectMake(0, textField.bounds.size.height - 1, textField.bounds.size.width, 1);
    [textField.layer addSublayer:bottomLineLayer];
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 2)];
    lineView.hidden = YES;
    lineView.center = bottomLineLayer.position;
    lineView.backgroundColor = self.mainColor;
    [textField addSubview:lineView];
    self.lineView = lineView;
    [self addSubview:textField];
    self.textField = textField;
    
    UILabel * placeLabel = [[UILabel alloc] initWithFrame:textField.frame];
    placeLabel.text = self.title;
    placeLabel.textColor = self.bottomColor;
    [self addSubview:placeLabel];
    self.label = placeLabel;
}

#pragma mark delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isShowTitle == NO) {
        [UIView animateWithDuration:DurationLabel animations:^{
            self.label.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8),CGAffineTransformMakeTranslation(-textField.bounds.size.width * 0.1, -textField.bounds.size.height));
            self.label.textColor = self.mainColor;
        } completion:^(BOOL finished) {
            textField.placeholder = self.hodler;
            _isShowTitle = YES;
        }];
    }
    self.lineView.hidden = NO;
    [UIView animateWithDuration:DurationLayer animations:^{
        self.lineView.transform = CGAffineTransformMakeScale(textField.bounds.size.width, 1);
    }];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.label.textColor == self.mainColor && string.length != 0) {
        self.label.textColor = [UIColor blackColor];
    }else if (textField.text.length == 1 && string.length == 0) {
        self.label.textColor = self.mainColor;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    textField.placeholder = @"";
    if (textField.text.length == 0) {
        [UIView animateWithDuration:DurationLabel animations:^{
            self.label.transform = CGAffineTransformIdentity;
            self.label.textColor = self.bottomColor;
        } completion:^(BOOL finished) {
            _isShowTitle = NO;
        }];
    }
    [UIView animateWithDuration:DurationLayer animations:^{
        self.lineView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.lineView.hidden = YES;
    }];
    return YES;
}

#pragma mark - set
- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = _title;
}

@end
