//
//  BQTools.m
//  Test
//
//  Created by baiqiang on 16/7/1.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "BQTools.h"
#import <objc/runtime.h>

@implementation BQTools
+ (void)showMessageWithTitle:(NSString *)title content:(NSString *)content {
    [self showMessageWithTitle:title content:content handle:nil];
}
+ (void)showMessageWithTitle:(NSString *)title content:(NSString *)content handle:(void (^)())clickedBtn {
    [self showMessageWithTitle:title content:content buttonTitles:@[@"确定"] clickedHandle:clickedBtn];
}
+ (void)showMessageWithTitle:(NSString *)title
                     content:(NSString *)content
                buttonTitles:(NSArray<NSString *> *)titles
               clickedHandle:(void (^)(NSInteger))clickedBtn
            compeletedHandle:(void (^)())handle{
    if (title == nil) {
        title = @"";
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *currentVc = [self currentViewController];
    NSInteger index = 0;
    for (NSString *btnTitle in titles) {
        [alertVc addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickedBtn != nil) {
                clickedBtn(index);
            }
        }]];
        ++index;
    }
    [currentVc presentViewController:alertVc animated:YES completion:^{
        if (handle != nil) {
            handle();
        }
    }];
}

+ (void)showMessageWithTitle:(NSString *)title
                     content:(NSString *)content
                buttonTitles:(NSArray <NSString *> *)titles
               clickedHandle:(void(^)(NSInteger index))clickedBtn {
    [self showMessageWithTitle:title content:content buttonTitles:titles clickedHandle:clickedBtn compeletedHandle:nil];
}

+ (void)encodeWithObject:(NSObject *)encodeObject
               withcoder:(NSCoder *)aCoder{
    //获取传入类
    Class cla = [encodeObject class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [encodeObject class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [encodeObject valueForKey:ivarKey];
            //归档设置
            [aCoder encodeObject:value forKey:ivarKey];
        }
        //释放数组
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
    
}

+ (void)unencodeWithObject:(NSObject *)unarchObject
                 withcoder:(NSCoder *)aDecoder{
    //获取传入类
    Class cla = [unarchObject class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [unarchObject class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置遍历数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [aDecoder decodeObjectForKey:ivarKey];
            //解档设置
            [unarchObject setValue:value forKey:ivarKey];
        }
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
}

+ (UIViewController *)currentViewController {
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (NSString *)currentSystemVersion {
   return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)currentBundleIdentifier {
    return [NSBundle mainBundle].bundleIdentifier;
}

+ (UIColor *)randomColor {
    UIColor * color = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
    return color;
}

+ (NSMutableArray *)valuesForamtToStringWithArray:(NSArray *)array {
    NSMutableArray * newArray = [NSMutableArray array];
    for (id obj in array) {
        id newObj;
        if ([obj isKindOfClass:[NSNumber class]]) {
            newObj = [NSString stringWithFormat:@"%@",obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            newObj = [self valuesForamtToStringWithDict:obj];
        }else if ([obj isKindOfClass:[NSArray class]]){
            newObj = [self valuesForamtToStringWithArray:obj];
        }else if ([obj isKindOfClass:[NSNull class]]){
            newObj = @"";
        }else {
            newObj = obj;
        }
        [newArray addObject:newObj];
    }
    return newArray;
}

+ (NSMutableDictionary *)valuesForamtToStringWithDict:(NSDictionary *)dict {
    __block NSMutableDictionary * newDict = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *newKey = [NSString stringWithFormat:@"%@",key];
        id newObj;
        if ([obj isKindOfClass:[NSNumber class]]) {
            newObj = [NSString stringWithFormat:@"%@",obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            newObj = [self valuesForamtToStringWithDict:obj];
        }else if ([obj isKindOfClass:[NSArray class]]){
            newObj = [self valuesForamtToStringWithArray:obj];
        }else if ([obj isKindOfClass:[NSNull class]]){
            newObj = @"";
        }else {
            newObj = obj;
        }
        newDict[newKey] = newObj;
    }];
    return newDict;
}


+ (NSMutableDictionary *)getKeychain {
    NSString * serveice = [self currentBundleIdentifier];
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,serveice,(id)kSecAttrService,serveice,(id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

+ (BOOL)saveKeychainWithData:(NSData *)data {
    NSMutableDictionary * keychainQuery = [self getKeychain];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:data forKey:(id)kSecValueData];
    OSStatus statu = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    return statu == noErr;
}

+ (BOOL)deleteKeyChainValue {
    NSMutableDictionary * keychainQuery = [self getKeychain];
    OSStatus statu =  SecItemDelete((CFDictionaryRef)keychainQuery);
    return statu == noErr;
}

+ (NSData *)loadKeyChainValue {
    NSMutableDictionary * keychainQuery = [self getKeychain];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef result = nil;
    SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&result);
    id data = nil;
    if (result != nil) {
        data = [NSData dataWithData:(__bridge NSData *)result];
        CFRelease(result);
    }
    return data;
}

+ (NSString *)jsonStringWithObject:(id)object {
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"jsonString format error:%@",error.localizedDescription);
        return nil;
    }
}

@end

