//
//  NSDictionary+Log.m
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "NSDictionary+Log.h"

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
