//
//  VisitStatisticsModel.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/23.
//

import Foundation
import Pjango

enum VisitStatisticsEventType: String {
    case visitIndex = "VISIT_INDEX"
    case visitProject = "VISIT_PROJECT"
    case visitAbout = "VISIT_ABOUT"
    case listPosts = "LIST_POSTS"
    case searchPosts = "SEARCH_POSTS"
    case readPosts = "READ_POSTS"
    case lovePosts = "LOVE_POSTS"
    case commentPosts = "COMMENT_POSTS"
    case leaveMessage = "LEAVE_MESSAGE"
}

class VisitStatisticsModel: PCModel {
    
    override var tableName: String {
        return "VisitStatistics"
    }
    
    var vid = PCDataBaseField.init(name: "VID", type: .string, length: 128)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20)
    var ip = PCDataBaseField.init(name: "IP", type: .string, length: 16)
    var port = PCDataBaseField.init(name: "PORT", type: .int)
    var from = PCDataBaseField.init(name: "FROM", type: .string, length: 2048)
    var event = PCDataBaseField.init(name: "EVENT", type: .string, length: 64)
    var param = PCDataBaseField.init(name: "PARAM", type: .string, length: 1024)

    override func registerFields() -> [PCDataBaseField] {
        return [
            vid, date, ip, port, from, event, param
        ]
    }
    
    
}
