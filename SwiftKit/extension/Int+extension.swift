//
//  Int+extension.swift
//  swift-Test
//
//  Created by MrBai on 2017/6/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

import UIKit

extension Int {
    
    /// 转化为距离字符串
    public var distance : String {
        
        guard self > 0 else {
            return ""
        }
        
        let unit = 1000.0
        guard Double(self) < unit else {
            return String(format:"%.1fkm",Double(self) / unit)
        }
        
        return "\(self)m"
    }
    
    /// 转化为文件大小字符串
    public var diskSize : String {
        
        guard self > 0 else {
            return ""
        }
        
        let unit = 1024.0
        guard Double(self) < unit * unit else {
            return String(format:"%.1fM",Double(self) / unit / unit)
        }
        
        guard Double(self) < unit else {
            return String(format:"%.0fKB",Double(self) / unit)
        }
        
        return "\(self)B"
    }
    /// 16进制数值转化为颜色
    public var hexColor : UIColor {
        
        guard self > 0 else {
            return UIColor.white
        }
        
        let red = (CGFloat)((self & 0xFF0000) >> 16) / 255.0
        let green = (CGFloat)((self & 0xFF00) >> 8) / 255.0
        let blue = (CGFloat)((self & 0xFF)) / 255.0
        
        //#available 进行系统版本条件判断
        if #available(iOS 10, *)
        {
            return UIColor(displayP3Red:red , green: green, blue: blue, alpha: 1.0)
        }
        
        guard #available(iOS 10, *) else {
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        return UIColor.black
    }
}
