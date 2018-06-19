//
//  ConfigModel.swift
//  Pjango-Dev
//
//  Created by 郑宇琦 on 2017/7/1.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

enum ConfigModelKey: String {
    
    case counterIndex = "counter_index"
    case counterPostsList = "counter_posts_list"
    case counterPostsSearch = "counter_posts_search"
    
    case name = "name"
    case indexMessage = "index_message"
    case titleMessage = "title_message"
    case postsListMessage = "posts_list_message"
    
    case instagramMessage = "instagram_message"
    case bilibiliName = "bilibili_name"
    case bilibiliMessage = "bilibili_message"
    
    case reportDailyMessage = "report_daily_message"
}

class ConfigModel: PCModel {
    
    override var tableName: String {
        return "LocalConfig"
    }
    
    var key = PCDataBaseField.init(name: "KEY", type: .string, length: 64)
    var value = PCDataBaseField.init(name: "VALUE", type: .string, length: 512)
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            key, value
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60
    }
    
    static func getValueForKey(_ key: ConfigModelKey) -> String? {
        let values = (self.queryObjects() as? [ConfigModel])?.filter {
            ($0.key.value as! String) == key.rawValue
        }.map {
            $0.value.value as! String
        }
        if values != nil, values!.count > 0 {
            return values![0]
        } else {
            return nil
        }
    }
    
    @discardableResult
    static func setValueForKey(_ key: ConfigModelKey, value: PCModelDataBaseFieldType) -> Bool {
        if let models = (self.queryObjects() as? [ConfigModel])?.filter({ ($0.key.value as! String) == key.rawValue }), let model = models.first {
            model.value.value = value
            return self.updateObject(model)
        } else {
            let model = ConfigModel.init()
            model.key.value = key.rawValue
            model.value.value = value
            return self.insertObject(model)
        }
        
    }
    
    override func initialObjects() -> [PCModel]? {
        return [
            ConfigModelKey.postsListMessage.rawValue: "主人还没有写寄语",
            ConfigModelKey.titleMessage.rawValue: "主人还没有设定座右铭",
            ConfigModelKey.name.rawValue: "主人还没有设定名字",
            ConfigModelKey.indexMessage.rawValue: "主人还没有设定主页寄语",
            ConfigModelKey.counterIndex.rawValue: "0",
            ConfigModelKey.counterPostsList.rawValue: "0",
            ConfigModelKey.counterPostsSearch.rawValue: "0",
        ].map {
            let config = ConfigModel.init()
            config.key.value = $0.key
            config.value.value = $0.value
            return config
        }
    }
    
}
