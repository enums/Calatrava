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
    case archivePosts = "ARCHIVE_POSTS"
    case listCorpus = "LIST_CORPUS"
    case listCorpusPosts = "LIST_CORPUS_POSTS"
    case readCorpusPosts = "READ_CORPUS_POSTS"
    case loveCorpusPosts = "LOVE_CORPUS_POSTS"
    case commentCorpusPosts = "COMMENT_CORPUS_POSTS"
    case leaveMessage = "LEAVE_MESSAGE"
    case blogUpdate = "BLOG_UPDATE"
    case visitInstagram = "VISIT_INSTAGRAM"
    case visitBilibili = "VISIT_BILIBILI"
    case reportDaily = "REPORT_DAILY"
    case reportTotal = "REPORT_TOTAL"
}

extension VisitStatisticsEventType {
    var displayValue: String {
        switch self {
        case .visitIndex: return "访问主页"
        case .visitProject: return "业余项目"
        case .visitAbout: return "查看关于"
        case .listPosts: return "查看博文列表"
        case .searchPosts: return "搜索博文"
        case .readPosts: return "阅读博文"
        case .lovePosts: return "点赞博文"
        case .commentPosts: return "评论博文"
        case .archivePosts: return "查看博文归档"
        case .listCorpus: return "查看文集列表"
        case .listCorpusPosts: return "查看文集文章列表"
        case .readCorpusPosts: return "阅读文集文章"
        case .loveCorpusPosts: return "点赞文集文章"
        case .commentCorpusPosts: return "评论文集文章"
        case .leaveMessage: return "留言"
        case .blogUpdate: return "查看动态聚合"
        case .visitInstagram: return "访问IG抓取"
        case .visitBilibili: return "访问原创视频"
        case .reportDaily: return "数据每日报告"
        case .reportTotal: return "数据统计报告"
        }
    }
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
