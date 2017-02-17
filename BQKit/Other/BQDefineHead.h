//
//  BQDefineHead.h
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//

/** ---------------- 屏幕宽高 ---------------  */
#define Screen_Widht [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
/** ---------------- 颜色设置 ---------------  */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)

/** ---------------- 输出调试 ---------------  */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"文件名:%s 行数:%d 输出:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif
