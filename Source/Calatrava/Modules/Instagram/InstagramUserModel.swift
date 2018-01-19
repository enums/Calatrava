//
//  InstagramUserModel.swift
//  Poster
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import Pjango

class InstagramUserModel: PCModel {
    
    override var tableName: String {
        return "InstagramUser"
    }
    
    var iid = PCDataBaseField.init(name: "IID", type: .string, length: 64)
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 256)
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 1024)

    override func registerFields() -> [PCDataBaseField] {
        return [
            iid, url, memo
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
