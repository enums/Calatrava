//
//  MessageModel.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/21.
//

import Foundation
import Pjango

class MessageModel: PCModel {
    
    override var tableName: String {
        return "Message"
    }
    
    var mid = PCDataBaseField.init(name: "MID", type: .string, length: 128)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 64)
    var email = PCDataBaseField.init(name: "EMAIL", type: .string, length: 64)
    var comment = PCDataBaseField.init(name: "COMMENT", type: .string, length: 2048)
    var fromIp = PCDataBaseField.init(name: "FROM_IP", type: .string, length: 16)
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            mid, date, name, email, comment, fromIp
        ]
    }
    
}
