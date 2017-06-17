//
//  UIImageView+extension.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//


//需导入Kingfisher三方库
import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(urlStr:String?) {
        guard let url = urlStr else {
            return
        }
        self.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
    }
    func canshow() {
        self.addTapGes {[weak self] (view) in
            guard let image = self?.image, let supView = self?.superview else{
                return
            }
            BQPhotoView.show(imgView: self!)
        }
    }
}
