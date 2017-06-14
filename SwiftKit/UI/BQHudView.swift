//
//  BQHudView.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/19.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

private let hudView = BQHudView()

class BQHudView: UIView {

    var title:String?
    var info:String!
    var block:(()->Void)?
    
    var showTimes: Int = 0
    var activeView: UIActivityIndicatorView?
    
    class func startActive() {
        hudView.showTimes += 1
        if hudView.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(hudView)
        }
        hudView.alpha = 1
        hudView.isHidden = false
    }
    class func endActive() {
        if hudView.showTimes > 0 {
            hudView.showTimes -= 1;
        }
        if hudView.showTimes == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                hudView.alpha = 0
            }) { (finish) in
                hudView.isHidden = true
            }
        }
    }
    private func loadView () {
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
        let center = self.center
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.setCorner(readius: 8)
        self.center = center
        self.activeView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.activeView?.startAnimating()
        self.activeView?.center = CGPoint(x: self.width * 0.5, y: 30)
        self.addSubview(self.activeView!)
        let lab = UILabel(frame: CGRect(x: 0, y: (self.activeView?.bottom)! - 10, width: self.width, height: self.height - (self.activeView?.bottom)! + 10))
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        lab.text = "加载中..."
        self.addSubview(lab)
    }
    class func show(info:String, title:String? = nil, complete:(()->Void)? = nil) {
        let msgView = BQHudView(frame: UIScreen.main.bounds, info: info, title: title, complete: complete)
        msgView.center = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
        UIApplication.shared.keyWindow?.addSubview(msgView)
        msgView.alpha = 0
        UIView.animate(withDuration: 0.25) { 
            msgView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            msgView.removeFromSuperview()
        }
    }
    init() {
        super.init(frame:UIScreen.main.bounds)
        self.loadView()
    }
    init(frame:CGRect, info:String, title:String?, complete:(()->Void)?) {
        super.init(frame:frame)
        self.info = info
        self.title = title
        self.block = complete
        self.createContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createContentView() {
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
        let width = self.width - 100
        var titleLab: UILabel?
        var maxWidth: CGFloat = 0
        
        if let title = self.title {
            let rect = title.boundingRect(with: CGSize(width: width, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
            let lab = UILabel(frame: rect)
            lab.numberOfLines = 0
            lab.font = UIFont.systemFont(ofSize: 16)
            lab.textColor = UIColor.white
            lab.text = title
            self.addSubview(lab)
            titleLab = lab
            maxWidth = lab.width
        }
        
        let infoRect = self.info.boundingRect(with: CGSize(width: width, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil)
        let contentLab = UILabel(frame: infoRect)
        contentLab.numberOfLines = 0
        contentLab.text = self.info
        contentLab.font = UIFont.systemFont(ofSize: 15)
        contentLab.textColor = UIColor.white
        self.addSubview(contentLab)
        maxWidth = maxWidth > contentLab.width ? maxWidth : contentLab.width
        self.width = maxWidth + 40
        
        if let lab = titleLab {
            self.height = lab.height + contentLab.height + 50
            lab.center = CGPoint(x: self.width * 0.5, y: 20 + lab.height * 0.5)
            contentLab.center = CGPoint(x: self.width * 0.5, y: lab.bottom + 10 + contentLab.height * 0.5)
        }else {
            self.height = contentLab.height + 40;
            contentLab.center = CGPoint(x: self.width * 0.5, y: 20 + contentLab.height * 0.5)
        }
        self.setCorner(readius: 8)
    }

}
