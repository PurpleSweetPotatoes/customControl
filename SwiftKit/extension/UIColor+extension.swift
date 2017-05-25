//
//  UIColor+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/18.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import Foundation
import UIKit

private let main_color = UIColor(red: 0xed / 255.0, green: 0xa6 / 255.0, blue: 0x2f / 255.0, alpha: 1)
private let text_color = UIColor(white: 0.4, alpha: 1)

private let line_color = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1)
extension UIColor {

    class var randomColor: UIColor {
        get {
            let red = Float(arc4random() % 256) / 255.0;
            let green = Float(arc4random() % 256) / 255.0;
            let blue = Float(arc4random() % 256) / 255.0;
            let color:UIColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
            return color;
        }
    }
    class var mainColor: UIColor {
        get {
            return main_color
        }
    }
    class var textColor: UIColor {
        get {
            return text_color
        }
    }
    class var lineColor: UIColor {
        get {
            return line_color
        }
    }
}
