//
//  EventHooks.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/7/1.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import PerfectHTTP
import Pjango

class EventHooks {
    
    static func hookIndex(req: HTTPRequest?) {
        addCountForKey(.counterIndex)
        StatisticsManager.statisticsEvent(eventType: .visitIndex, req: req)
    }
    
    static func hookAbout(req: HTTPRequest?) {
        StatisticsManager.statisticsEvent(eventType: .visitAbout, req: req)
    }
    
    static func hookProject(req: HTTPRequest?) {
        StatisticsManager.statisticsEvent(eventType: .visitProject, req: req)
    }
    
    static func hookPostsList(req: HTTPRequest?) {
        addCountForKey(.counterPostsList)
        StatisticsManager.statisticsEvent(eventType: .listPosts, req: req)
    }
    
    static func hookPostsSearch(req: HTTPRequest?, keyword: String?) {
        addCountForKey(.counterPostsSearch)
        StatisticsManager.statisticsEvent(eventType: .searchPosts, param: keyword, req: req)
    }
    
    static func hookPostsRead(req: HTTPRequest?, pid: Int) {
        StatisticsManager.statisticsEvent(eventType: .readPosts, param: "\(pid)", req: req)
    }

    static func hookPostsLove(req: HTTPRequest?, pid: Int) {
        StatisticsManager.statisticsEvent(eventType: .lovePosts, param: "\(pid)", req: req)
    }
    
    static func hookPostsComment(req: HTTPRequest?, pid: Int) {
        StatisticsManager.statisticsEvent(eventType: .commentPosts, param: "\(pid)", req: req)
    }
    
    static func hookCorpusList(req: HTTPRequest?) {
        addCountForKey(.counterPostsList)
        StatisticsManager.statisticsEvent(eventType: .listCorpus, req: req)
    }
    
    static func hookCorpusPostsList(req: HTTPRequest?, cid: Int) {
        StatisticsManager.statisticsEvent(eventType: .listCorpusPosts, param: "\(cid)", req: req)
    }
    
    static func hookCorpusPostsRead(req: HTTPRequest?, cpid: Int) {
        StatisticsManager.statisticsEvent(eventType: .readCorpusPosts, param: "\(cpid)", req: req)
    }

    static func hookCorpusPostsLove(req: HTTPRequest?, cpid: Int) {
        StatisticsManager.statisticsEvent(eventType: .lovePosts, param: "\(cpid)", req: req)
    }
    
    static func hookCorpusPostsComment(req: HTTPRequest?, cpid: Int) {
        StatisticsManager.statisticsEvent(eventType: .commentPosts, param: "\(cpid)", req: req)
    }
    
    static func hookLeaveMessage(req: HTTPRequest?) {
        StatisticsManager.statisticsEvent(eventType: .leaveMessage, req: req)
    }

    static internal func addCountForKey(_ key: ConfigModelKey) {
        if Int(ConfigModel.getValueForKey(key) ?? "") == nil {
            ConfigModel.setValueForKey(key, value: "0")
        }
        guard let oldCounter = Int(ConfigModel.getValueForKey(key) ?? "") else {
            return
        }
        ConfigModel.setValueForKey(key, value: "\(oldCounter + 1)")
    }
    
    
    
}
