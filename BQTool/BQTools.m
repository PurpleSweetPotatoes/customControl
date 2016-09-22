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

+ (void)showMessageWithTitle:(NSString *)title
                     content:(NSString *)content {
    [self showMessageWithTitle:title content:content buttonTitles:@[@"确定"] clickedHandle:nil];
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

+ (void)showMessageWithTitle:(NSString *)title
                     content:(NSString *)content
                 disMissTime:(NSTimeInterval)time {
    if (title == nil) {
        title = @"";
    }
    if (time == 0) {
        time = 0.75f;
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *currentVc = [self currentViewController];
    [currentVc presentViewController:alertVc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        });
    }];
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
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus statu = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
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
        data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)result];
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

//----------------------- model输出格式调整 ----------
@implementation NSObject (Log)
+ (void)load {
    // 交换两个方法的实现
    method_exchangeImplementations(class_getInstanceMethod([NSObject class], @selector(description)), class_getInstanceMethod([NSObject class], @selector(pkxDescription)));
}
/**
 *  该方法是用来自定义模型(直接继承NSObject)的输出格式
 *
 *  @return 格式化后的字符串
 */
- (NSString *)pkxDescription{
    Class class = [self class];
    NSMutableString *resultStr = [NSMutableString stringWithFormat:@"%@ = {\n",[self pkxDescription]];
    while (class != [NSObject class]) {
        // 0.如果是UIResponder或CALayer的子类,就使用系统的默认输出格式
        NSString * description = [class description];
        if ([description hasPrefix:@"NS"] || [description hasPrefix:@"__"]|| [description hasPrefix:@"AV"] || [description hasPrefix:@"_UIFlowLayout"] || [description hasPrefix:@"UITouchesEvent"] || [description hasPrefix:@"MP"] || [class isSubclassOfClass:[UIResponder class]] || [class isSubclassOfClass:[CALayer class]] || [class isSubclassOfClass:[UIImage class]])return [self pkxDescription];
        unsigned int count = 0;
        //　1.获取类成员变量列表，count为类成员变量数量
        Ivar *vars = class_copyIvarList(class, &count);
        for (int index = 0; index < count; index ++) {
            // 2.根据索引获得指定位置的成员变量
            Ivar var = vars[index];
            // 3.获得成员变量名
            const char *name = ivar_getName(var);
            // 4.成员变量名转化成oc字符串
            NSString *varName = [NSString stringWithUTF8String:name];
            varName = [varName substringFromIndex:1];
            // 5.获得成员变量对应的值
            id value = [self valueForKey:varName];
            [resultStr appendFormat:@"\t%@ = %@;\n", varName, value];
        }
        // 6.释放指针
        free(vars);
        // 7.获得父类
        class = class_getSuperclass(class);
    }
    [resultStr appendString:@"}\n"];
    return resultStr;
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
        
        hasValue = YES;
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
        [str appendFormat:@"%@,\n", obj];
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




