//
//  BilibiliFeedModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/5/20.
//

import Foundation
import Pjango

class BilibiliFeedModel: PCModel {
    
    override var tableName: String {
        return "BilibiliFeed"
    }
    
    var bvid = PCDataBaseField.init(name: "BVID", type: .int)
    var blid = PCDataBaseField.init(name: "BLID", type: .int)
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 1024)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 256, notNull: true, defaultValue: "null")
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 1024)
    var cover = PCDataBaseField.init(name: "COVER", type: .string, length: 1024, notNull: true, defaultValue: "null")
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20, notNull: true, defaultValue: "1970-01-01 08:00")
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            bvid, blid, url, name, memo, cover, date
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
