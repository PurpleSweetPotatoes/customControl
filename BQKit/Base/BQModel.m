//
//  BQModel.m
//  MyCocoPods
//
//  Created by baiqiang on 16/10/28.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

#import "BQModel.h"
#import <objc/runtime.h>

@implementation BQModel
+ (NSMutableArray *)mallocWithArray:(NSArray *)array {
    NSMutableArray * models = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        BQModel * model = [self mallocWithDict:dict];
        [models addObject:model];
    }
    return models;
}
+ (instancetype)mallocWithDict:(NSDictionary *)infoDict {
    BQModel * model = [self new];
    if (infoDict.allKeys.count == 0) {
        return model;
    }
    unsigned int ivarCount = 0;
    //获取传入类成员变量列表
    Ivar *ivarArray = class_copyIvarList(model.class, &ivarCount);
    unsigned int count = ivarCount;
    for (int i = 0; i < count; i ++) {
        //得到变量名字
        const char *name = ivar_getName(ivarArray[i]);
        //char* 转化为 NSString 类型
        NSString *ivarKey = [[NSString stringWithUTF8String:name] substringFromIndex:1];
        if (infoDict[ivarKey] != nil) {
            [model setValue:infoDict[ivarKey] forKey:ivarKey];
        }
    }
    free(ivarArray);
    return model;
}
- (NSString *)description
{
    unsigned int ivarCount = 0;
    //获取传入类成员变量列表
    Ivar *ivarArray = class_copyIvarList(self.class, &ivarCount);
    unsigned int count = ivarCount;
    NSMutableString * result = [NSMutableString stringWithFormat:@"\n<%@:%p",NSStringFromClass(self.class),self];
    if (count > 0) {
        [result appendString:@"\n"];
    }
    for (int i = 0; i < count; i ++) {
        //得到变量名字
        const char *name = ivar_getName(ivarArray[i]);
        //char* 转化为 NSString 类型
        NSString *ivarKey = [[NSString stringWithUTF8String:name] substringFromIndex:1];
        id value = [self valueForKey:ivarKey];
        NSString * str = [NSString stringWithFormat:@" %@ : %@\n",ivarKey,value];
        [result appendString:str];
    }
    [result appendString:@">"];
    free(ivarArray);
    return result;
}
@end
