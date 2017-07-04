//
//  EventHooks.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/7/1.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import PerfectHTTP
import Pjango

class EventHooks {
    
    static func hookIndex() {
        addCountForKey(.counterIndex)
    }
    
    static func hookPostsList() {
        addCountForKey(.counterPostsList)
    }
    
    static func hookPostsSearch() {
        addCountForKey(.counterPostsSearch)
    }
    
    static func addCountForKey(_ key: ConfigModelKey) {
        if Int(ConfigModel.getValueForKey(key) ?? "") == nil {
            ConfigModel.setValueForKey(key, value: "0")
        }
        guard let oldCounter = Int(ConfigModel.getValueForKey(key) ?? "") else {
            return
        }
        ConfigModel.setValueForKey(key, value: "\(oldCounter + 1)")
    }
}
