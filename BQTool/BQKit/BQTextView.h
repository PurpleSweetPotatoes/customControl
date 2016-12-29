//
//  BQTextView.h
//  Test
//
//  Created by MAC on 16/12/29.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 The TextView have placeHolder
 */
@interface BQTextView : UITextView <UITextViewDelegate>

@property (nonatomic, copy) NSString *placeholder;

+(instancetype)createWithFrame:(CGRect)frame
                   placeholder:(NSString *)placeholderStr;

-(instancetype)initWithFrame:(CGRect)frame
                 placeholder:(NSString *)placeholderStr;
@end
