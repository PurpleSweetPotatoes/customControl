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
        self.kf.setImage(with: URL(string: urlStr!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
    }
    func canshow() {
        self.addTapGes {[weak self] (view) in
            if let image = self?.image {
                BQShowImageView.show(img: image, origiFrame: (self?.frame)!)
            }
        }
    }
}

var startCenter: CGPoint = CGPoint(x:0, y:0)
var startScale: CGFloat = 1

class BQShowImageView: UIView {
    let imageView: UIImageView = UIImageView()
    let backView: UIView = UIView(frame: UIScreen.main.bounds)
    var origiFrame: CGRect! {
        didSet {
            self.imageView.frame = self.origiFrame
        }
    }
    
    class func show(img:UIImage, origiFrame:CGRect) {
        let showView = BQShowImageView(frame: UIScreen.main.bounds)
        showView.initUI()
        showView.imageView.image = img
        showView.origiFrame = origiFrame
        showView.addTapGes {[weak showView] (view) in
            showView?.removeSelf()
        }
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(showView)
        showView.startShow()
    }
    private func initUI() {
        self.backView.backgroundColor = UIColor(white: 0.2, alpha: 0.7)
        self.addSubview(self.backView)
        self.imageView.isUserInteractionEnabled = true
        self.backView.addSubview(self.imageView)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.gestureAction(gesture:)))
        self.imageView.addGestureRecognizer(pan)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.gestureAction(gesture:)))
        self.imageView.addGestureRecognizer(pinch)
    }
    @objc private func gestureAction(gesture:UIGestureRecognizer) {
        if gesture is UIPanGestureRecognizer {
            switch gesture.state {
            case .began:
                startCenter = self.imageView.center
            case .changed:
                let pan = gesture as! UIPanGestureRecognizer
                let translation = pan.translation(in: self)
                self.imageView.center = CGPoint(x: startCenter.x + translation.x, y: startCenter.y + translation.y)
            case .ended:
                startCenter = CGPoint(x:0, y:0)
            default:
                break
            }
        }else if gesture is UIPinchGestureRecognizer {
            let pinch = gesture as! UIPinchGestureRecognizer
            switch gesture.state {
            case .began:
                startScale = pinch.scale
            case .changed:
                let scale = (pinch.scale - startScale) + 1
                self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
                startScale = pinch.scale
            case .ended:
                startScale = 1
            default:
                break
            }
        }
    }
    private func startShow() {
        self.backView.alpha = 0;
        let toWidth = self.width - 10;
        let toHeight = self.imageView.height * toWidth / self.imageView.width;
        UIView.animate(withDuration: 0.25) { 
            self.backView.alpha = 1;
            self.imageView.bounds = CGRect(x:0, y:0, width:toWidth, height:toHeight);
            self.imageView.center = self.center;
        }
    }
    private func removeSelf() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.imageView.frame = self.origiFrame!
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
}
