//
//  AppDelegate.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import SwiftyJSON
import PerfectHTTP
import Pjango
import PjangoMySQL
import PjangoPostman

class AppDelegate: PjangoDelegate {
    
    func setSettings() {
        
        // Pjango
        #if os(macOS)
            PJANGO_WORKSPACE_PATH = APP_CONFIG.string(forKey: "macos_workspace_path") ?? "/Calatrava"
        #else
            PJANGO_WORKSPACE_PATH = APP_CONFIG.string(forKey: "workspace_path") ?? "/Calatrava"
        #endif
        
        PJANGO_LOG_DEBUG = APP_CONFIG.bool(forKey: "log_debug") ?? true
        
        PJANGO_SERVER_PORT = UInt16(APP_CONFIG.int(forKey: "port") ?? 80)
        
        PJANGO_LOG_PATH = APP_CONFIG.string(forKey: "log_path") ?? "pjango.log"
        
        // Django
        
        PJANGO_BASE_DIR = APP_CONFIG.string(forKey: "base_dir") ?? ""
        
        PJANGO_TEMPLATES_DIR = APP_CONFIG.string(forKey: "templates") ?? "templates"
        
        PJANGO_STATIC_URL = APP_CONFIG.string(forKey: "static") ?? "static"
    }
    
    func setUrls() -> [String: [PCUrlConfig]]? {
        
        return [
            
            PJANGO_HOST_DEFAULT: [
                pjangoUrl("", name: "index", handle: IndexView.asHandle()),
                pjangoUrl("404", name: "error.404", handle: ErrorNotFoundView.asHandle()),
                pjangoUrl("not_support", name: "error.notsupport", handle: ErrorNotSupportView.asHandle()),
            ],
            
            WEBSITE_HOST: [
                pjangoUrl("", name: "index", handle: IndexView.asHandle()),
                pjangoUrl("modules", name: "modules", handle: ModuleListView.asHandle()),
                pjangoUrl("about", name: "about", handle: AboutView.asHandle()),
                pjangoUrl("update", name: "update", handle: UpdateListView.asHandle()),
                
                // search
                pjangoUrl("search", name: "search", handle: SearchView.asHandle()),
                pjangoUrl("search_result", name: "search.result", handle: SearchResultListView.asHandle()),
                
                // project
                pjangoUrl("project", name: "project", handle: ProjectListView.asHandle()),
                
                // report
                pjangoUrl("report/daily/today", name: "report.daily.today", handle: ReportDailyView.asHandle()),
                pjangoUrl("report/daily/{date}", name: "report.daily", handle: ReportDailyView.asHandle()),
                pjangoUrl("report/total/{opt}", name: "report.total", handle: ReportTotalView.asHandle()),
                
                // posts
                pjangoUrl("posts/list", name: "posts.list", handle: PostsListView.asHandle()),
                pjangoUrl("posts/article/{pid}", name: "posts.posts", handle: PostsView.asHandle()),
                pjangoUrl("posts/archive", name: "posts.archive", handle: PostsArchiveView.asHandle()),
                pjangoUrl("posts/search", name: "posts.search", handle: PostsSearchView.asHandle()),
                
                // corpus
                pjangoUrl("corpus/list", name: "corpus.list", handle: CorpusListView.asHandle()),
                pjangoUrl("corpus/list/{cid}", name: "corpus.corpus", handle: CorpusPostsListView.asHandle()),
                pjangoUrl("corpus/article/{cpid}", name: "corpus.posts", handle: CorpusPostsView.asHandle()),
                
                // instagram
                pjangoUrl("instagram/list", name: "instagram.list", handle: InstagramListView.asHandle()),
                pjangoUrl("instagram/resource", name: "instagram.resource", handle: InstagramCurlHandle),
                
                // bilibili
                pjangoUrl("bilibili/list", name: "bilibili.list", handle: BilibiliListView.asHandle()),
                
                // API
                pjangoUrl("api/posts/love", name: "api.posts.love", handle: postsLoveHandle),
                pjangoUrl("api/posts/comment", name: "api.posts.comment", handle: postsCommentHandle),
                
                pjangoUrl("api/corpus/love", name: "api.corpus.love", handle: corpusPostsLoveHandle),
                pjangoUrl("api/corpus/comment", name: "api.corpus.comment", handle: corpusPostsCommentHandle),
                
                pjangoUrl("api/verification", name: "api.verification@corpus", handle: verificationHandle),
                pjangoUrl("api/message", name: "api.message", handle: messageHandle),
            ],
        ]
    }
    
    func setDB() -> PCDataBase? {
        return MySQLDataBase.init(param: [
            "SCHEMA": APP_CONFIG.string(forKey: "mysql_schema") ?? "Pjango_calatrava",
            "USER": APP_CONFIG.string(forKey: "mysql_user") ?? "",
            "PASSWORD": APP_CONFIG.string(forKey: "mysql_password") ?? "",
            "HOST": APP_CONFIG.string(forKey: "mysql_host") ?? "127.0.0.1",
            "PORT":  UInt16(APP_CONFIG.int(forKey: "mysql_schema") ?? 3306),
            ])
    }
    
    func registerModels() -> [PCModel]? {
        return [
            ModuleModel.meta,
            PostsModel.meta,
            PostsTagModel.meta,
            PostsCommentModel.meta,
            PostsHistoryModel.meta,
            ProjectModel.meta,
            
            ConfigModel.meta,
            MessageModel.meta,
            
            VisitStatisticsModel.meta,
            
            CorpusModel.meta,
            CorpusPostsModel.meta,
            CorpusPostsCommentModel.meta,
            
            InstagramUserModel.meta,
            InstagramFeedModel.meta,
            
            PostmanConfigModel.meta,
            
            BilibiliListModel.meta,
            BilibiliFeedModel.meta,
            
            ReportDailyModel.meta,
        ]
    }

    func registerPlugins() -> [PCPlugin]? {
        return [
            PCLogFilterPlugin.meta,
            NotFoundFilterPlugin.meta,
            DailyCleanPlugin.meta,
            InstagramTimerPlugin.meta,
            ReportUpdatePlugin.meta,
            ReportGeneratePlugin.meta,
        ]
    }
    
}
