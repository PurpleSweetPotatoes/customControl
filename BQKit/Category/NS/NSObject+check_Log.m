//
//  NSObject+Check_Log.m
//  MyCocoPods
//
//  Created by baiqiang on 16/10/28.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "NSObject+check_Log.h"
#import <objc/runtime.h>
@implementation NSObject (Check_Log)

- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary * obj = (NSDictionary *)self;
        if (obj.allKeys.count > 0) {
            return NO;
        }
    }else if ([self isKindOfClass:[NSArray class]]) {
        NSArray * obj = (NSArray *)self;
        if (obj.count > 0) {
            return NO;
        }
    }else if ([self isKindOfClass:[UITextField class]]) {
        UITextField * obj = (UITextField *)self;
        if (obj.text.length > 0) {
            return NO;
        }
    }else if ([self isKindOfClass:[UITextView class]]) {
        UITextView * obj = (UITextView *)self;
        if (obj.text.length > 0) {
            return NO;
        }
    }
    return YES;
}
@end

//----------------------- 字典数组中文输出调整 ----------
@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    // 遍历字典的所有键值对
    __block BOOL hasValue = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
            [str appendFormat:@"\t\"%@\":%@,\n", key, obj];
        }else {
            [str appendFormat:@"\t\"%@\":\"%@\",\n", key, obj];
        }
        if (hasValue == NO) {
            hasValue = YES;
        }
    }];
    
    [str appendString:@"}"];
    
    if (hasValue == YES) {
        // 查出最后一个,的范围
        NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    // 遍历数组的所有元素
    __block BOOL hasValue = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (hasValue == NO) {
            hasValue = YES;
        }
        [str appendFormat:@"\t%@,\n", obj];
    }];
    [str appendString:@"]"];
    if (hasValue == YES) {
        // 查出最后一个,的范围
        NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    return str;
}
@end
