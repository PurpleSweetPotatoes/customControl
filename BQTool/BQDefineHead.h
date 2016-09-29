//
//  BQDefineHead.h
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//

/** ---------------- 子线程执行block ---------------  */
#define async(block) dispatch_async(dispatch_get_global_queue(0, 0), ^{ block })

/** ---------------- 主线程执行block ---------------  */
#define sync(block) dispatch_async(dispatch_get_main_queue(), ^{ block })
/** ---------------- 屏幕宽高 ---------------  */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/** ---------------- 颜色设置 ---------------  */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1)

/** ---------------- 输出调试 ---------------  */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"文件名:%s 行数:%d 输出:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif