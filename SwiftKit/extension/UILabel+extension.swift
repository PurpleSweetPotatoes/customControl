//
//  UILabel+extension.swift
//  swift-Test
//
//  Created by MrBai on 2017/6/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

import UIKit

extension UILabel {
    
    @discardableResult
    func adjustHeightForFont(spacing:CGFloat) -> CGFloat {
        if let content = self.text {
            let rect = content.boundingRect(with: CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:self.font], context: nil)
            self.height = rect.height + spacing
            return rect.height
        }
        return self.height
    }
    
    @discardableResult
    func adjustWidthForFont() -> CGFloat {
        if let content = self.text {
            let rect = content.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.height), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:self.font], context: nil)
            self.width = rect.width
            return rect.width
        }
        return self.width
    }
}
