//
//  ProjectModel.swift
//  Pjango-Dev
//
//  Created by 郑宇琦 on 2017/7/1.
//
//

import Foundation
import Pjango

class ProjectModel: PCModel {
    
    override var tableName: String {
        return "Project"
    }
    
    var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
    var subtitle = PCDataBaseField.init(name: "SUBTITLE", type: .string, length: 64)
    var tag = PCDataBaseField.init(name: "TAG", type: .string, length: 64)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 10)
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 256)
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 512)
    
    var tagModel: [PostsTagModel] {
        let tagList = (tag.value as! String).components(separatedBy: "|")
        PostsTagModel.updateHtmlDictIfNeed()
        
        return tagList.flatMap {
            PostsTagModel.htmlDict[$0]
        }
    }

    override func registerFields() -> [PCDataBaseField] {
        return [
            title, subtitle, tag, date, url, memo
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
    
}

