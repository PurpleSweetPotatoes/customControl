//
//  CALayer+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/18.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    class func lineLayer(frame: CGRect) -> CAShapeLayer {
        let line = CAShapeLayer()
        line.frame = frame
        line.backgroundColor = UIColor.lineColor.cgColor
        return line
    }
    
    var left : CGFloat {
        get {
            return self.frame.origin.x
        }
        set(left) {
            self.frame.origin = CGPoint(x: left, y: self.frame.origin.y)
        }
    }
    var right : CGFloat {
        get {
            return self.frame.origin.x + self.width
        }
        set(right) {
            self.left = right - self.width
        }
    }
    var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        set(top) {
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: top)
        }
    }
    var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.height
        }
        set(bottom) {
            self.top = bottom - self.height
        }
    }
    var width : CGFloat {
        get {
            return self.bounds.size.width
        }
        set(width) {
            self.frame.size = CGSize(width: width, height: self.frame.height)
        }
    }
    var height : CGFloat {
        get {
            return self.bounds.size.height
        }
        set(height) {
            self.frame.size = CGSize(width: self.width, height: height)
        }
    }
}
