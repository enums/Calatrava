//
//  AppDelegate.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import PerfectHTTP
import Pjango

class AppDelegate: PjangoDelegate {
    
    func setSettings() {
        
        // Pjango
        
        #if os(macOS)
            PJANGO_WORKSPACE_PATH = "/Users/Enum/Developer/GitHub/Calatrava/Workspace"
        #else
            PJANGO_WORKSPACE_PATH = ""
        #endif
        
        
        PJANGO_LOG_DEBUG = true
        
        PJANGO_SERVER_PORT = 80
        
        PJANGO_LOG_PATH = "runtime/calatrava.log"
        
        // Django
        
        PJANGO_BASE_DIR = ""
        
        PJANGO_TEMPLATES_DIR = "templates"
        
        PJANGO_STATIC_URL = "static"
        
    }
    
    func setUrls() -> [String: [PCUrlConfig]]? {
        
        return [
            PJANGO_HOST_DEFAULT: [
                pjangoUrl("", name: "index", handle: IndexView.asHandle()),
                pjangoUrl("404", name: "error.404", handle: ErrorNotFoundView.asHandle()),
            ],

            WEBSITE_HOST: [
                pjangoUrl("", name: "index", handle: IndexView.asHandle()),
                pjangoUrl("about", name: "about", handle: AboutView.asHandle()),
            ],

            "posts.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: PostsListView.asHandle()),
                pjangoUrl("posts/{pid}", name: "posts", handle: PostsView.asHandle()),
                pjangoUrl("search", name: "search", handle: PostsSearchView.asHandle()),
                
                pjangoUrl("api/love", name: "api.love", handle: postsLoveHandle),
                
            ],
            
            "project.\(WEBSITE_HOST)": [
                pjangoUrl("list", name: "list", handle: ProjectListView.asHandle()),
            ],
        ]
    }
    
    func setDB() -> PCDataBase? {
        return PCFileDBDataBase.init(param: [
                "SCHEMA": "default",
                "PATH": "\(PJANGO_WORKSPACE_PATH)/filedb"
            ])
    }
    
    func registerModels() -> [PCModel]? {
        return [
            ConfigModel.meta,
            PostsModel.meta,
            PostsTagModel.meta,
            PostsHistoryModel.meta,
            ProjectModel.meta,
        ]
    }
    
    func registerPlugins() -> [PCPlugin]? {
        return [
            PCLogFilterPlugin.meta,
            NotFoundFilterPlugin.meta,
        ]
    }
    
}
