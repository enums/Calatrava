//
//  PostsTagModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsTagModel: PCModel {
    
    override var tableName: String {
        return "PostsTag"
    }
    
    var tag = PCDataBaseField.init(name: "TAG", type: .string, length: 16)
    var label = PCDataBaseField.init(name: "LABEL", type: .string, length: 16)
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            tag, label
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
    static var htmlDict = [String: PostsTagModel]()
    static var htmlDictUpdateTime: TimeInterval = 0
    
    static func updateHtmlDictIfNeed() {
        guard let tagObjs = queryObjects(), Date.init().timeIntervalSince1970 - htmlDictUpdateTime > cacheTime! else {
            return
        }
        var htmlDict = [String: PostsTagModel]()
        tagObjs.forEach {
            let tagModel = $0 as! PostsTagModel
            htmlDict[tagModel.tag.value as! String] = tagModel
        }
        self.htmlDict = htmlDict
        
    }

}
