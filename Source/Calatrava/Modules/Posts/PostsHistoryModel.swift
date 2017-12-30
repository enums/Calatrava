//
//  PostsHistoryModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsHistoryModel: PCModel {
    
    override var tableName: String {
        return "PostsHistory"
    }
    
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 10)
    var content = PCDataBaseField.init(name: "CONTENT", type: .string, length: 64)
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            date, content
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }

}

