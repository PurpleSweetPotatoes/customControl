//
//  UIButton+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/16.
//  Copyright © 2017年 baiqiang. All rights reserved.
//
import UIKit

enum BtnSubViewAdjust {
    case none
    case left
    case right
    case imgTopTitleBottom
}

extension UIButton {
    class func mainColorBtn(frame:CGRect, title:String?) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.backgroundColor = UIColor.mainColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setCorner(readius: 5)
        btn.setTitle(title, for: .normal)
        return btn
    }
    class func borderBtn(frame:CGRect, title:String?) -> UIButton {
        let btn = UIButton(frame: frame)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.mainColor, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setCorner(readius: 5)
        btn.setBordColor(color: UIColor.mainColor)
        return btn
    }
    class func createCornerBtn(frame:CGRect, color:UIColor, title:String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.setCorner(readius: btn.width * 0.5)
        btn.setBordColor(color: color)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        return btn
    }
    
    /// 调整btn视图和文字位置()
    ///
    /// - Parameters:
    ///   - spacing: 调整后的间距
    ///   - type: 调整方式BtnSubViewAdjust
    func adjustImageTitle(spacing: CGFloat, type: BtnSubViewAdjust) {
        //重置内间距、防止获取视图位置出错
        self.imageEdgeInsets = UIEdgeInsets.zero
        self.titleEdgeInsets = UIEdgeInsets.zero
        if type == .none {
            return
        }
        guard let imgView = self.imageView, let titleLab = self.titleLabel else {
            print("check you btn have image and text!")
            return
        }
        let width = self.frame.width
        var imageLeft: CGFloat = 0
        var imageTop: CGFloat = 0
        var titleLeft: CGFloat = 0
        var titleTop: CGFloat = 0
        var titleRift: CGFloat = 0
        if type == .imgTopTitleBottom {
            imageLeft = (width - imgView.frame.width) * 0.5 - imgView.frame.origin.x
            imageTop = spacing - imgView.frame.origin.y
            titleLeft = (width - titleLab.frame.width) * 0.5 - titleLab.frame.origin.x - titleLab.frame.origin.x
            titleTop = spacing * 2 + imgView.frame.height - titleLab.frame.origin.y
            titleRift = -titleLeft - titleLab.frame.origin.x * 2
        }else if type == .left {
            imageLeft = spacing - imgView.frame.origin.x
            titleLeft = spacing * 2 + imgView.frame.width - titleLab.frame.origin.x
            titleRift = -titleLeft
        }else {
            titleLeft = width - titleLab.frame.maxX - spacing
            titleRift = -titleLeft
            imageLeft = width - imgView.right - spacing * 2 - titleLab.frame.width
        }
        self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft, -imageTop, -imageLeft)
        self.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, -titleTop, titleRift)
    }
}
