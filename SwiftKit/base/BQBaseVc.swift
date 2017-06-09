//
//  BQBaseVc.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/16.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit

class BQBaseVc: UIViewController, UINavigationControllerDelegate {
    let contentView = UIScrollView()
    var ishideNavBar = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.delegate = self;
        self.view.backgroundColor = UIColor.randomColor
        self.contentView.frame = self.view.bounds
        if self.navigationController != nil {
            self.contentView.height = UIScreen.main.bounds.size.height - 64
        }
        self.contentView.bounces = false
        self.contentView.contentSize = self.contentView.size
        self.contentView.showsVerticalScrollIndicator = false
        self.contentView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.contentView)
        if let navVc = self.navigationController {
            if navVc.viewControllers.index(of: self) != 0 {
//TODO: 设置返回按钮
                let leftBarItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.leftBarItemAction))
                self.navigationItem.leftBarButtonItem = leftBarItem
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutContentView()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func leftBarItemAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    func hideNavBar() -> Void {
        self.contentView.top = 0
        self.contentView.height = UIScreen.main.bounds.size.height
        self.ishideNavBar = true
    }
    func showNavBar() -> Void {
        self.contentView.top = 64
        self.contentView.height = UIScreen.main.bounds.size.height - 64
        self.ishideNavBar = false
    }
    func layoutContentView() -> Void {
        var maxHeight: CGFloat = 0
        for view in self.contentView.subviews {
            if view.bottom > maxHeight {
                maxHeight = view.bottom
            }
        }
        self.contentView.contentSize = CGSize(width: self.contentView.width, height: maxHeight)
    }
    //MARK:- ***** navgationDelegate *****
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as! BQBaseVc
        navigationController.delegate = vc
        self.navigationController?.setNavigationBarHidden(vc.ishideNavBar, animated: true)
    }
}
extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
