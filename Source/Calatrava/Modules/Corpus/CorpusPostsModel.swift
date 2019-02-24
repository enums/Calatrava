//
//  CorpusPostsModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/29.
//

import Foundation
import Pjango

class CorpusPostsModel: PCModel {
    
    override var tableName: String {
        return "CorpusPosts"
    }
    
    var cpid = PCDataBaseField.init(name: "CPID", type: .int)
    var cid = PCDataBaseField.init(name: "CID", type: .int)
    var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 16)
    var read = PCDataBaseField.init(name: "READ", type: .int)
    var love = PCDataBaseField.init(name: "LOVE", type: .int)
    
    var commentsCount: Int {
        if let comments = (CorpusPostsCommentModel.queryObjects() as? [CorpusPostsCommentModel])?.filter({ $0.cpid.intValue == cpid.intValue }) {
            return comments.count
        } else {
            return 0
        }
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            cpid, cid, title, date, read, love
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
