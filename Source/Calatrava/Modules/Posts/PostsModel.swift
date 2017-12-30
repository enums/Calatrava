//
//  PostsModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsModel: PCModel {
    
    override var tableName: String {
        return "Posts"
    }
    
    var pid = PCDataBaseField.init(name: "PID", type: .int)
    var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 16)
    var read = PCDataBaseField.init(name: "READ", type: .int)
    var love = PCDataBaseField.init(name: "LOVE", type: .int)
    var tag = PCDataBaseField.init(name: "TAG", type: .string, length: 64)
    
    var tagModel: [PostsTagModel] {
        let tagList = (tag.value as! String).components(separatedBy: "|")
        PostsTagModel.updateHtmlDictIfNeed()

        return tagList.flatMap {
                PostsTagModel.htmlDict[$0]
            }
    }
    
    var commentsCount: Int {
        if let comments = PostsCommentModel.queryObjects()?.filter({ ($0 as! PostsCommentModel).pid.intValue == pid.intValue }) {
            return comments.count
        } else {
            return 0
        }
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            pid, title, date, read, love, tag
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }

}
