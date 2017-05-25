//
//  UIFont+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/18.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class var navTitleFont: UIFont {
        get {
            return self.adjust(size: 36)
        }
    }
    class var textFont: UIFont {
        get {
            return self.adjust(size: 30)
        }
    }
    class var smallTextFont: UIFont {
        get {
            return self.adjust(size: 26)
        }
    }
    class func adjust(size:CGFloat) -> UIFont {
        return self.systemFont(ofSize: BQAdjust(x: size))
    }
}
