//
//  UIButton+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/16.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import Foundation
import UIKit

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
}
