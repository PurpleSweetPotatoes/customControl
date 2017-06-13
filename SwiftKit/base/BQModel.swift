//
//  BQModel.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/19.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit
//import SwiftyJSON

class BQModel: NSObject {
    required override init() {
        
    }
    required init(_ dic: Dictionary<String,Any>) {
        super.init()
        self.configValue(dic)
    }
    func configValue(_ dic: Dictionary<String,Any>) {
        let mirror = Mirror(reflecting: self)
        for p in mirror.children {
            let name = p.label!
            if let value = dic[name] {
                if value is Dictionary<String, Any> && self.value(forKey: name) is BQModel {
                    (self.value(forKey: name) as! BQModel).configValue(value as! Dictionary<String, Any>)
                }else {
                    self.setValue(value, forKey: name)
                }
            }
        }
    }
    override var description: String {
        let mirror = Mirror(reflecting: self)
        var result = [String:Any]()
        for p in mirror.children {
            let name = p.label!
            result[name] = p.value
        }
        return String(describing: "<\(self.classForCoder):\(Unmanaged.passRetained(self).toOpaque())>\n\(result)")
    }
    //MARK:- ***** if has SWIFTJSON can use this Mesthod *****
    //    required init(_ json: JSON) {
    //        super.init()
    //        self.configValue(json)
    //    }
    //    func configValue(_ json: JSON) {
    //        if let modelInfo = json.dictionary {
    //            let mirror = Mirror(reflecting: self)
    //            for p in mirror.children {
    //                let name = p.label!
    //                if let value = modelInfo[name] {
    //                    switch value.type {
    //                    case .string:
    //                        self.setValue(value.string, forKey: name)
    //                    case .number:
    //                        self.setValue(value.number, forKey: name)
    //                    case .bool:
    //                        self.setValue(value.bool, forKey: name)
    //                    case .dictionary:
    //                        let val = self.value(forKey: name)
    //                        if val is BQModel {
    //                            (val as! BQModel).configValue(value)
    //                        }else {
    //                            self.setValue(value.dictionary, forKey: name)
    //                        }
    //                    case .array:
    //                        self.setValue(value.array, forKey: name)
    //                    default:
    //                        break
    //                    }
    //                }
    //            }
    //        }
    //    }
}

extension Array where Element: BQModel {
    static func modelArr(arr: Array<Dictionary<String,Any>>) -> Array<Element> {
        var result = [Element]()
        for dic in arr {
            result.append(Element(dic))
        }
        return result
    }
    //MARK:- ***** if has SWIFTJSON can use this Mesthod *****
    //    static func modelArr(arr: Array<JSON>) -> Array<Element> {
    //        var result = [Element]()
    //        for json in arr {
    //            result.append(Element(json))
    //        }
    //        return result
    //    }
}
