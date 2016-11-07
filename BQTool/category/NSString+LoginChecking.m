//
//  NSString+LoginChecking.m
//  正则表达式
//
//  Created by baiqiang on 15/8/8.
//  Copyright (c) 2015年 baiqiang. All rights reserved.
//

#import "NSString+LoginChecking.h"

@implementation NSString (LoginChecking)

- (BOOL)isQQ {
    return [self match:@"^[1-9]\\d{4,10}"];
}
- (BOOL)isPhoneNumber {
    return [self match:@"^(13|14|15|17|18)\\d{9}$"];
}
- (BOOL)isIPAddress {
    return [self match:@"\\d{0,3}\\.\\d{0,3}.\\d{0,3}.\\d{0,3}"];
}
- (BOOL)isMailbox {
    return [self match:@"^.*@..+\\.[a-zA-Z]{2,4}$"];
}
- (BOOL)isCardId {
    return [self match:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"];
}
- (BOOL)match:(NSString *)string {
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:string options:NSRegularExpressionCaseInsensitive error:nil];
    //2.测试字符串
    NSArray *results = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return results.count;
}
- (BOOL)hasUnicode {

    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}
@end
