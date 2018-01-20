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
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 1024)
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 1024)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 256)
    var full_name = PCDataBaseField.init(name: "FULL_NAME", type: .string, length: 256)
    var bio = PCDataBaseField.init(name: "BIO", type: .string, length: 1024)
    var head = PCDataBaseField.init(name: "HEAD", type: .string, length: 1024)
    var updateDate = PCDataBaseField.init(name: "UPDATE_DATE", type: .string, length: 20)

    override func registerFields() -> [PCDataBaseField] {
        return [
            iid, url, memo, name, full_name, bio, head, updateDate
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
