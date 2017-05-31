//
//  String+extension.swift
//  HJLBusiness
//
//  Created by baiqiang on 2017/5/24.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

import Foundation

infix operator =~ : Regular
precedencegroup Regular {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}


var Regular_Phone = "^(13|14|15|17|18)\\d{9}$"
var Regular_Email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
var Regular_CardId = "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"
var Regular_IPAdrress = "^\\d{0,3}\\.\\d{0,3}.\\d{0,3}.\\d{0,3}$"

extension String {
    func isPhone() -> Bool {
        return self =~ Regular_Phone
    }
    func isEmail() -> Bool {
        return self =~ Regular_Email
    }
    func isCard() -> Bool {
        return self =~ Regular_CardId
    }
    func isIPAddress() -> Bool{
        return self =~ Regular_IPAdrress
    }
    //正则表达判断,lhs:字符串,rhs:正则式
    static func =~(lhs: String, rhs: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: rhs, options: .caseInsensitive)
            let matches = regex.matches(in: lhs, options: [], range: NSMakeRange(0, lhs.characters.count))
            return matches.count > 0
        } catch {
            return false
        }
    }
    subscript(index: Int) -> Character {
        get {
            return self[self.index(startIndex, offsetBy: index)]
        }
        set {
            let rangeIndex = self.index(startIndex, offsetBy: index)
            self.replaceSubrange(rangeIndex...rangeIndex, with: String(newValue))
        }
    }
}

extension Character {
    func toInt() -> Int
    {
        var intFromCharacter:Int = 0
        for scalar in String(self).unicodeScalars
        {
            intFromCharacter = Int(scalar.value)
        }
        return intFromCharacter
    }
}
