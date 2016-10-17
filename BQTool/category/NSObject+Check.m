//
//  NSObject+Check.m
//  NavgationBar-Test
//
//  Created by baiqiang on 16/10/17.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "NSObject+Check.h"

@implementation NSObject (Check)
- (BOOL)isEmpty {
    if ([self isKindOfClass:[NSString class]]) {
        NSString * obj = (NSString *)self;
        if (obj.length > 0) {
            return NO;
        }
        return YES;
    }else if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary * obj = (NSDictionary *)self;
        if (obj.allKeys.count > 0) {
            return NO;
        }
        return YES;
    }else if ([self isKindOfClass:[NSArray class]]) {
        NSArray * obj = (NSArray *)self;
        if (obj.count > 0) {
            return NO;
        }
        return YES;
    }
    return YES;
}
@end
