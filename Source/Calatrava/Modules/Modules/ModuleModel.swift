//
//  ModuleModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/12/6.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ModuleModel: PCModel {
    
    override var tableName: String {
        return "Module"
    }
    
    var title = PCDataBaseField.init(name: "TITLE", type: .string, length: 64)
    var icon = PCDataBaseField.init(name: "ICON", type: .string, length: 64)
    var memo = PCDataBaseField.init(name: "MEMO", type: .string, length: 128)
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 128)
    
    var realUrl: String {
        get {
            let urlDict = [
                "_pjango_url_posts_list": pjangoUrlReverse(host: "posts.\(WEBSITE_HOST)", name: "list") ?? "",
                "_pjango_url_corpus_list": pjangoUrlReverse(host: "corpus.\(WEBSITE_HOST)", name: "list") ?? "",
                "_pjango_url_project_list": pjangoUrlReverse(host: "project.\(WEBSITE_HOST)", name: "list") ?? "",
                "_pjango_url_instagram_list": pjangoUrlReverse(host: "instagram.\(WEBSITE_HOST)", name: "list") ?? "",
                "_pjango_url_bilibili_list": pjangoUrlReverse(host: "bilibili.\(WEBSITE_HOST)", name: "list") ?? "",
                "_pjango_url_update": pjangoUrlReverse(host: WEBSITE_HOST, name: "update") ?? "",
                "_pjango_url_report": pjangoUrlReverse(host: WEBSITE_HOST, name: "report.daily.today") ?? "",
                "_pjango_url_about": pjangoUrlReverse(host: WEBSITE_HOST, name: "about") ?? "",
                ]
            return urlDict[self.url.strValue] ?? ""
        }
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            title, icon, memo, url
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
    
}
