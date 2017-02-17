//
//  BQTextView.h
//  TextFeildTest
//
//  Created by baiqiang on 16/8/13.
//  Copyright © 2016年 白强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQTextFieldView : UIView
/**  展示标题 */
@property (nonatomic, copy) NSString * title;
/**  提示文字 */
@property (nonatomic, copy) NSString * hodler;
/**  文本框(代理为本类,提示文字通过hodler设定)*/
@property (nonatomic, strong) UITextField * textField;

- (instancetype)initWithFrame:(CGRect)frame mainColor:(UIColor *)color;
- (instancetype)initWithFrame:(CGRect)frame mainColor:(UIColor *)color title:(NSString *)title hodler:(NSString *)hodler;
@end
