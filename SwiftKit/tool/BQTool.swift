//
//  BQTool.swift
//  HaoJiLai
//
//  Created by baiqiang on 16/11/1.
//  Copyright © 2016年 baiqiang. All rights reserved.
//

import UIKit


class BQTool: NSObject {
    
    //MARK:- ***** 弹出框 *****
    class func showAlert(content:String, title:String? = nil, handle:(() -> ())? = nil) {
        self.showAlert(content: content, title: title, btnTitleArr: ["确定"]) { (index) in
            if let block = handle {
                block()
            }
        }
    }
    class func showAlert(content:String, title:String? = nil, btnTitleArr:Array<String>,handle:@escaping ((_ index:Int) -> Void)) {
        let alertVc:UIAlertController = UIAlertController.init(title: title, message: content, preferredStyle: UIAlertControllerStyle.alert);
        for title in btnTitleArr {
            let action:UIAlertAction = UIAlertAction.init(title: title, style: UIAlertActionStyle.default, handler: { (action) in
                let index = btnTitleArr.index(of: action.title!)
                handle(index!)
            })
            alertVc.addAction(action)
        }
        self.currentVc().present(alertVc, animated: true, completion: nil)
    }
    class func currentVc() -> UIViewController {
        var vc:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while let presentVc = vc.presentedViewController {
            vc = presentVc
        }
        return vc
    }
    class func getFuntionUseTime(function:()->()) {
        let start = CACurrentMediaTime()
        function()
        let end = CACurrentMediaTime()
        Log("方法耗时为：\(end-start)")
    }
    //MARK:- ***** 应用设置跳转 *****
    class func gotoAppSystemSet() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    class func callPhone(_ str:String) {
        if let url = URL(string: "telprompt://" + str) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    //MARK:- ***** 对象转json *****
    class func jsonFromObject(obj:Any) -> String {
        let data:Data = try! JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        let json:String = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        return json
    }
    class func currentBundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier!
    }
    //MARK:- ***** 钥匙串保存 *****
    //if want to use this method should open keychain sharing
    @discardableResult
    class func saveKeychain(data:Data) -> Bool {
        var keychainQuery = self.getkeychain()
        SecItemDelete(keychainQuery as CFDictionary)
        keychainQuery[kSecValueData as String] = data as AnyObject?
        let statu = SecItemAdd(keychainQuery as CFDictionary, nil)
        return statu == noErr
    }
    @discardableResult
    class func deleteKeyChain() -> Bool {
        let keychainQuery = self.getkeychain()
        let statu = SecItemDelete(keychainQuery as CFDictionary)
        return statu == noErr
    }
    class func loadKeychain() -> Data? {
        var keychainQuery = self.getkeychain()
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue as AnyObject
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne as AnyObject
        var result: AnyObject?
        let statu = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(keychainQuery as CFDictionary, UnsafeMutablePointer($0))
        }
        if statu == noErr {
            return result as? Data
        }
        return nil
    }
    //MARK:- ***** private Method *****
    private class func getkeychain() -> Dictionary<String,AnyObject> {
        let serveice = self.currentBundleIdentifier()
        return Dictionary(dictionaryLiteral: (kSecClass as String,kSecClassGenericPassword as AnyObject),(kSecAttrService as String ,serveice as AnyObject),(kSecAttrAccount as String,serveice as AnyObject),(kSecAttrAccessible as String,kSecAttrAccessibleAfterFirstUnlock as AnyObject))
    }
}

/// 需要在build setting -> other swift flags -> Debug 中设置 -D DEBUG
func Log<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName)-line:\(lineNum) ==> \(messsage)")
    #endif
}
