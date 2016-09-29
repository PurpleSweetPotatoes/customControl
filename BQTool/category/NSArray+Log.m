//
//  NSArray+Log.m
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "NSArray+Log.h"

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
