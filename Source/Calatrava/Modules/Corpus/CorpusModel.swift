//
//  CorpusModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/29.
//

import Foundation
import Pjango

class CorpusModel: PCModel {
    
    override var tableName: String {
        return "Corpus"
    }
    
    var cid = PCDataBaseField.init(name: "CID", type: .int)
    var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 1024)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 16)
    
    var updateDate: String {
        if let comments = (CorpusPostsModel.queryObjects() as? [CorpusPostsModel])?.filter({ $0.cid.intValue == cid.intValue }) {
            guard let last = comments.last else {
                return date.strValue
            }
            return last.date.strValue
        } else {
            return date.strValue
        }

    }

    override func registerFields() -> [PCDataBaseField] {
        return [
            cid, title, memo, date
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
}
