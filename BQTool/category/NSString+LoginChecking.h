//
//  NSString+LoginChecking.h
//  正则表达式
//
//  Created by baiqiang on 15/8/8.
//  Copyright (c) 2015年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LoginChecking)

/**  是否为QQ账号 */
- (BOOL)isQQ;

/**  是否为电话号码 */
- (BOOL)isPhoneNumber;

/**  是否为IP地址 */
- (BOOL)isIPAddress;

/**  是否为邮箱 */
- (BOOL)isMailbox;

/**  是否为身份证 */
- (BOOL)isCardId;

/**  是否含有unicode编码 */
- (BOOL)hasUnicode;
@end
