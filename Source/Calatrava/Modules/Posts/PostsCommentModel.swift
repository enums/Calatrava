//
//  PostsCommentModel.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/18.
//

import Foundation
import Pjango

class PostsCommentModel: PCModel {
    
    override var tableName: String {
        return "PostsComment"
    }
    
    var pcid = PCDataBaseField.init(name: "PCID", type: .string, length: 128)
    var pid = PCDataBaseField.init(name: "PID", type: .int)
    var floor = PCDataBaseField.init(name: "FLOOR", type: .int)
    var refer_floor = PCDataBaseField.init(name: "REFER_FLOOR", type: .int)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 64)
    var email = PCDataBaseField.init(name: "EMAIL", type: .string, length: 64)
    var comment = PCDataBaseField.init(name: "COMMENT", type: .string, length: 2048)
    var fromIp = PCDataBaseField.init(name: "FROM_IP", type: .string, length: 16)

    override func registerFields() -> [PCDataBaseField] {
        return [
            pcid, pid, floor, refer_floor, date, name, email, comment, fromIp
        ]
    }

}
