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
            UIView.animate(withDuration: 0.3, animations: {
                keyView?.frame = CGRect(origin: CGPoint(x: 0, y: self.keyBoardOrigiY - self.viewBottom), size: UIScreen.main.bounds.size)
            });
            self.keyBoardOrigiY = 0
        }else {
            if keyView!.frame != UIScreen.main.bounds {
                UIView.animate(withDuration: 0.25, animations: {
                    keyView?.frame = UIScreen.main.bounds
                })
            }
        }
    }
    @objc private func keyBoardWillDismiss(notifi:Notification) {
        
        UIView.animate(withDuration: 0.25) {
            UIApplication.shared.keyWindow?.rootViewController?.view.frame = UIScreen.main.bounds
        }
    }
    @objc private func didBeginEditing(notifi:Notification) {
        self.currentTF = notifi.object as? UIView
        let keyView = UIApplication.shared.keyWindow?.rootViewController?.view
        let rect = (self.currentTF?.superview?.convert((self.currentTF?.frame)!, to: keyView))!
        self.viewBottom = rect.maxY
        self.adjustViewHeight()
    }
    @objc private func didEndEditing(notifi:Notification) {
        self.keyBoardOrigiY = 0
        self.viewBottom = 0
        self.forntOrigiY = 0
    }
}
