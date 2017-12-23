//
//  Extension.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation


var dateFormatter = { () -> DateFormatter in
    let that = DateFormatter.init()
    that.timeZone = TimeZone.init(secondsFromGMT: 8 * 3600)
    that.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return that
}()

var dayFormatter = { () -> DateFormatter in
    let that = DateFormatter.init()
    that.timeZone = TimeZone.init(secondsFromGMT: 8 * 3600)
    that.dateFormat = "YYYY-MM-dd"
    return that
}()

extension Date {
    var stringValue: String {
        get {
            return dateFormatter.string(from: self)
        }
    }
    var dayStringValue: String {
        get {
            return dayFormatter.string(from: self)
        }
    }
    
    static var today: Date {
        get {
            let date = Date.init()
            let todayStr = dayFormatter.string(from: date)
            return dayFormatter.date(from: todayStr)!
        }
    }
    
    static var tomorrow: Date {
        return Date.init(timeInterval: 3600 * 24, since: today)
    }
    
    static var yestoday: Date {
        get {
            return Date.init(timeInterval: -3600 * 24, since: today)
        }
    }
}
