//
//  Global.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

#if os(macOS)
let WEBSITE_HOST = "calatravatest.com"
#else
let WEBSITE_HOST = "enumsblog.com"
#endif

let logger = PCLog.init(tag: "Calatrava-Blog")
let statisticsLogger = PCLog.init(tag: "Statistics")

//pid@ip
var postsLoveDict = Set<String>.init()

//pid@ip
var postsCommentLastTimeDict = Dictionary<String, TimeInterval>.init()
//pid@ip
var postsCommentDailyDict = Dictionary<String, Int>.init()


//cpid@ip
var corpusPostsLoveDict = Set<String>.init()

//cpid@ip
var corpusPostsCommentLastTimeDict = Dictionary<String, TimeInterval>.init()
//cpid@ip
var corpusPostsCommentDailyDict = Dictionary<String, Int>.init()

//pid@ip
var messageLastTimeDict = Dictionary<String, TimeInterval>.init()
//pid@ip
var messageDailyDict = Dictionary<String, Int>.init()

//pid@ip
var verificationLastTimeDict = Dictionary<String, TimeInterval>.init()

// instagram
var instagramFeed = [InstagramFeed].init()
let instagramFeedLock = NSLock.init()


