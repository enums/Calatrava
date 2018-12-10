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
            ],
            
            "project.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: ProjectListView.asHandle()),
            ],
            
            "playground.\(WEBSITE_HOST)": [
                pjangoUrl("swift", name: "swift", handle: ErrorNotSupportView.asHandle()),
            ],
            
            WEBSITE_HOST: [
                pjangoUrl("", name: "index", handle: IndexView.asHandle()),
                pjangoUrl("modules", name: "modules", handle: ModuleListView.asHandle()),
                pjangoUrl("about", name: "about", handle: AboutView.asHandle()),
                pjangoUrl("update", name: "update", handle: UpdateListView.asHandle()),
                pjangoUrl("report/daily/today", name: "report.daily.today", handle: ReportDailyView.asHandle()),
                pjangoUrl("report/daily/{date}", name: "report.daily", handle: ReportDailyView.asHandle()),
                pjangoUrl("report/total/{opt}", name: "report.total", handle: ReportTotalView.asHandle()),

                pjangoUrl("api/message", name: "api.message", handle: messageHandle),
                pjangoUrl("api/verification", name: "api.verification@index", handle: verificationHandle),
                
                //Old
                pjangoUrl("post", name: "old.posts.1", handle: postsOldHandle),
                pjangoUrl("posts", name: "old.posts.2", handle: postsOldHandle),
                pjangoUrl("playground", name: "old.playground", handle: ErrorNotSupportView.asHandle()),
            ],
            
            "posts.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: PostsListView.asHandle()),
                pjangoUrl("posts/{pid}", name: "posts", handle: PostsView.asHandle()),
                pjangoUrl("search", name: "search", handle: PostsSearchView.asHandle()),
                pjangoUrl("archive", handle: PostsArchiveView.asHandle()),
                
                pjangoUrl("api/love", name: "api.love@posts", handle: postsLoveHandle),
                pjangoUrl("api/comment", name: "api.comment@posts", handle: postsCommentHandle),
                
                pjangoUrl("api/verification", name: "api.verification@posts", handle: verificationHandle),
            ],
            
            "corpus.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: CorpusListView.asHandle()),
                pjangoUrl("list/{cid}", name: "corpus.list", handle: CorpusPostsListView.asHandle()),
                pjangoUrl("corpus/{cpid}", name: "corpus.posts", handle: CorpusPostsView.asHandle()),
                
                pjangoUrl("api/love", name: "api.love@corpus", handle: corpusPostsLoveHandle),
                pjangoUrl("api/comment", name: "api.comment@corpus", handle: corpusPostsCommentHandle),
                pjangoUrl("api/verification", name: "api.verification@corpus", handle: verificationHandle),
            ],
            
            "instagram.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: InstagramListView.asHandle()),
                pjangoUrl("resource", name: "resource", handle: InstagramCurlHandle),
                
                // old
                pjangoUrl("feed", name: "feed", handle: InstagramListView.asHandle()),
            ],
            
            "bilibili.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: BilibiliListView.asHandle()),
                
                // old
                pjangoUrl("feed", name: "feed", handle: BilibiliListView.asHandle()),
            ]
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
