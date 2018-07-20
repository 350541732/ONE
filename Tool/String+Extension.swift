//
//  String+Extension.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
extension String {
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}

extension String {
    func description() -> String {
        switch self {
        case "01":
            return "Jan."
        case "02":
            return "Feb."
        case "03":
            return "Mar."
        case "04":
            return "Jan."
        case "05":
            return "May."
        case "06":
            return "Jun."
        case "07":
            return "Jul."
        case "08":
            return "Aug."
        case "09":
            return "Sep."
        case "10":
            return "Oct."
        case "11":
            return "Nov."
        case "12":
            return "Dec."
        default:
            return "Unknown"
        }
    }
}
