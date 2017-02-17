//
//  MF_Base64Codec.h
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MF_Base64Codec : NSObject
+(NSData *)dataFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromData:(NSData *)data;
+(NSString *)base64UrlEncodedStringFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromBase64UrlEncodedString:(NSString *)base64UrlEncodedString;
@end
