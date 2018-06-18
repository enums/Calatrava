//
//  BilibiliListModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/5/20.
//

import Foundation
import Pjango

class BilibiliListModel: PCModel {
    
    override var tableName: String {
        return "BilibiliList"
    }
    
    var blid = PCDataBaseField.init(name: "BLID", type: .int)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 256, notNull: true, defaultValue: "null")
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 1024)
    
    var updateDate: String {
        if let comments = (BilibiliFeedModel.queryObjects() as? [BilibiliFeedModel])?.filter({ $0.blid.intValue == blid.intValue }) {
            guard let last = comments.last else {
                return "1970-01-01 08:00"
            }
            return last.date.strValue
        } else {
            return "1970-01-01 08:00"
        }
        
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            blid, name, memo
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
