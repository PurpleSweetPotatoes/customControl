//
//  BQKeyManager.swift
//  swift-test
//
//  Created by baiqiang on 2017/6/1.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit
private let shareManager = BQKeyManager()
class BQKeyManager: NSObject {
    private var isRegister = false
    private var currentTF: UIView!
    private var oldFrame: CGRect = UIScreen.main.bounds
    private var viewBottom: CGFloat = 0
    private var keyBoardOrigiY: CGFloat = 0
    private var forntOrigiY: CGFloat = 0
    private func startManager() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillDisplay(notifi:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillDismiss(notifi:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(didBeginEditing(notifi:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didBeginEditing(notifi:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didEndEditing(notifi:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didEndEditing(notifi:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    class func start() {
        if !shareManager.isRegister {
            shareManager.startManager()
            shareManager.isRegister = true
        }
    }
    class func close() {
        if shareManager.isRegister {
            NotificationCenter.default.removeObserver(self)
            shareManager.isRegister = false
        }
    }
    deinit {
        if self.isRegister {
            NotificationCenter.default.removeObserver(self)
        }
    }
    @objc private func keyBoardWillDisplay(notifi:Notification) {
        
        //获取userInfo
        let kbInfo = notifi.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyBoardOrigiY = kbRect.origin.y
        self.adjustViewHeight()
    }
    private func adjustViewHeight() {
        if self.keyBoardOrigiY == 0 || self.viewBottom == 0 {
            return
        }
        let keyView = UIApplication.shared.keyWindow?.rootViewController?.view
        if self.keyBoardOrigiY < self.viewBottom {
            self.forntOrigiY = self.keyBoardOrigiY
            keyView?.frame = self.oldFrame
            UIView.animate(withDuration: 0.3, animations: {
                keyView?.frame = CGRect(origin: CGPoint(x: self.oldFrame.origin.x, y: self.keyBoardOrigiY - self.viewBottom), size: self.oldFrame.size)
            });
            self.keyBoardOrigiY = 0
            self.viewBottom = 0
        }
        if self.forntOrigiY != 0 && self.forntOrigiY < self.keyBoardOrigiY {
            UIView.animate(withDuration: 0.25, animations: {
                keyView?.frame = CGRect(origin: CGPoint(x: self.oldFrame.origin.x, y:self.oldFrame.origin.y + self.keyBoardOrigiY - self.forntOrigiY), size: self.oldFrame.size)
            });
        }
    }
    @objc private func keyBoardWillDismiss(notifi:Notification) {
        
        UIView.animate(withDuration: 0.25) {
            UIApplication.shared.keyWindow?.rootViewController?.view.frame = UIScreen.main.bounds
        }
    }
    @objc private func didBeginEditing(notifi:Notification) {
        self.currentTF = notifi.object as? UIView
        self.oldFrame = (UIApplication.shared.keyWindow?.rootViewController?.view.frame)!
        let keyView = UIApplication.shared.keyWindow?.rootViewController?.view
        keyView?.frame = self.oldFrame
        let rect = (self.currentTF?.superview?.convert((self.currentTF?.frame)!, to: keyView))!
        self.viewBottom = rect.maxY
        self.adjustViewHeight()
    }
    @objc private func didEndEditing(notifi:Notification) {
        self.oldFrame = UIScreen.main.bounds
        self.keyBoardOrigiY = 0
        self.viewBottom = 0
        self.forntOrigiY = 0
    }
}

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
