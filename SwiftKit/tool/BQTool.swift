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
    class func showAlert(content:String) -> Void {
        self.showAlert(title: "温馨提示", content: content)
    }
    class func showAlert(content:String,clickBlock:(() -> Void)?) -> Void {
        self.showAlert(title: "温馨提示", content: content, btnTitleArr: ["确定"]) { (index) in
            if clickBlock != nil {
                clickBlock!()
            }
        }
    }
    class func showAlert(title:String, content:String) -> Void {
        self.showAlert(title: title, content: content, btnTitleArr: ["确定"], handle: nil)
    }
    class func showAlert(title:String, content:String,clickBlock:(() -> Void)?) -> Void {
        self.showAlert(title: title, content: content, btnTitleArr: ["确定"]) { (index) in
            if clickBlock != nil {
                clickBlock!()
            }
        }
    }
    class func showAlert(title:String, content:String ,btnTitleArr:Array<String>,handle:((_ index:Int) -> Void)?) -> Void {
        let alertVc:UIAlertController = UIAlertController.init(title: title, message: content, preferredStyle: UIAlertControllerStyle.alert);
        for title in btnTitleArr {
            let action:UIAlertAction = UIAlertAction.init(title: title, style: UIAlertActionStyle.default, handler: { (action) in
                if handle != nil {
                    let index = btnTitleArr.index(of: action.title!)
                    handle!(index!)
                }
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
    class func pwdEncryt(pwd:String) -> String {
        let base64 = pwd.data(using: .utf8)?.base64EncodedString()
        let lenght = base64?.characters.count
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM"
        let key = formatter.string(from: Date()).md5()
        let keyLenght = key.characters.count
        var tempStr = String()
        var x = 0
        for _ in 0..<lenght! {
            if x == keyLenght {
                x = 0
            }
            let index = key.index(key.startIndex, offsetBy: x)
            tempStr.append(key[index])
            x += 1
        }
        var backStr = String();
        var index: String.Index
        for i in 0 ..< lenght! {
            index = (base64?.index((base64?.startIndex)!, offsetBy: i))!
            let firstASC = base64![index]
            let lastASC = tempStr[index]
            backStr = backStr.appendingFormat("%d ",(firstASC.toInt() + lastASC.toInt()))
        }
    
        index = backStr.index(backStr.endIndex, offsetBy: -1)
        var result = backStr.substring(to:index)
        result = (result.data(using: .utf8)?.base64EncodedString())!
        return result
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
    class func saveKeychain(data:Data) -> Bool {
        var keychainQuery = self.getkeychain()
        SecItemDelete(keychainQuery as CFDictionary)
        keychainQuery[kSecValueData as String] = data as AnyObject?
        let statu = SecItemAdd(keychainQuery as CFDictionary, nil)
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
    class func deleteKeyChain() -> Bool {
        let keychainQuery = self.getkeychain()
        let statu = SecItemDelete(keychainQuery as CFDictionary)
        return statu == noErr
    }
    
    private class func getkeychain() -> Dictionary<String,AnyObject> {
        let serveice = self.currentBundleIdentifier()
        return Dictionary(dictionaryLiteral: (kSecClass as String,kSecClassGenericPassword as AnyObject),(kSecAttrService as String ,serveice as AnyObject),(kSecAttrAccount as String,serveice as AnyObject),(kSecAttrAccessible as String,kSecAttrAccessibleAfterFirstUnlock as AnyObject))
    }
    class func creteRowTF(top:CGFloat, height:CGFloat, title:String, holder:String?, superView: UIView) -> UITextField {
        let view = UIView(frame: CGRect(x: 0, y: top, width: UIScreen.main.bounds.size.width, height: height))
        let label = UILabel(frame: CGRect(x: BQAdjust(x: 40), y: 0, width: BQAdjust(x: 140), height: height))
        label.font = UIFont.textFont
        label.text = title
        view.addSubview(label)
        
        let textField = UITextField(frame: CGRect(x: label.right, y: 0, width: UIScreen.main.bounds.size.width - label.right - BQAdjust(x: 40), height: height))
        textField.placeholder = holder
        textField.textColor = UIColor.textColor
        textField.font = UIFont.textFont
        textField.text = ""
        view.addSubview(textField)
        
        view.layer.addSublayer(CALayer.lineLayer(frame: CGRect(x: 0, y: height - 1, width: view.width, height: 1)))
        superView.addSubview(view)
        return textField
    }
    class func saveAccountPwd(name:String, pwd:String) {
        UserDefaults.standard.set(name, forKey: "account")
        UserDefaults.standard.synchronize()
        let dic = ["account":name,"password":pwd]
        let data = BQTool.jsonFromObject(obj: dic).data(using: .utf8)
        if BQTool.saveKeychain(data: data!) {
            Log("登录信息保存成功")
        }else {
            Log("登录信息保存失败")
        }
    }
}

/// 需要在build setting -> other swift flags -> Debug 中设置 -D DEBUG
func Log<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName)-line:\(lineNum) ==> \(messsage)")
    #endif
}
