//
//  UIView+AdjustScreen.swift
//  HaoJiLai
//
//  Created by baiqiang on 16/11/2.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

import UIKit
//MARK:- ***** 类联函数 *****
//实际屏幕与设计宽度的比例
@inline(__always) func BQScale() -> CGFloat {
    let width = UIScreen.main.bounds.size.width
    return width / 750.0
}

@inline(__always) func BQAdjust(x:CGFloat) -> CGFloat {
    return x * BQScale()
}
@inline(__always) func BQAdjustSize(width:CGFloat, height:CGFloat) -> CGSize {
    let size = CGSize(width: width * BQScale(), height: height * BQScale())
    return size
}
@inline(__always) func BQAdjustPoint(x:CGFloat, y:CGFloat) -> CGPoint {
    let point = CGPoint(x: x * BQScale(), y: y * BQScale())
    return point
}
@inline(__always) func BQAdjustFrame(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> CGRect {
    let rect = CGRect(origin: BQAdjustPoint(x: x, y: y), size: BQAdjustSize(width: width, height: height))
    return rect
}
//MARK:- ***** 视图位置调整 *****
extension UIView {
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
    var size: CGSize {
        get {
            return self.bounds.size
        }
        set(size) {
            self.frame.size = size
        }
    }
    func setCorner(readius:CGFloat) -> Void {
        self.layer.cornerRadius = readius
        self.clipsToBounds = true
    }
    func setBordColor(color:UIColor) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
    
    //MARK: ---- 添加点击手势
    typealias addBlock = (_ imageView: UIView) -> Void
    
    private struct AssociatedKeys {
        static var actionKey = "actionBlock"
    }
    private var action: addBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.actionKey) as? addBlock
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.actionKey, newValue!, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    func addTagGes(action:@escaping (_ view: UIView) -> Void) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        self.isUserInteractionEnabled = true
        self.action = action
        self.addGestureRecognizer(gesture)
    }
    @objc private func tapGestureAction() {
        if let action = self.action {
            action(self)
        }
    }
}



