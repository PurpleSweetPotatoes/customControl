//
//  BQModel.swift
//  HJLBusiness
//
//  Created by MrBai on 2017/5/19.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import UIKit
import SwiftyJSON

class BQModel: NSObject {
    required init(dic: JSON) {
        super.init()
        if let modelInfo = dic.dictionary {
            let mirror = Mirror(reflecting: self)
            print(mirror.subjectType)
            for p in mirror.children {
                let name = p.label!
                if let value = modelInfo[name] {
                    switch value.type {
                    case .string:
                        self.setValue(value.string, forKey: name)
                    case .number:
                        self.setValue(value.number, forKey: name)
                    default:
                        break
                    }
                }
            }
        }
    }
    class func model(dic: JSON) -> Self{
        return self.init(dic: dic)
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
}

extension Array where Element: BQModel {
    static func modelArr(arr: Array<JSON>) -> Array<Element> {
        var result = [Element]()
        for dic in arr {
            result.append(Element(dic: dic))
        }
        return result
    }
}
