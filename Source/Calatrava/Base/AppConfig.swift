//
//  AppConfig.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/12/10.
//

import Foundation
import SwiftyJSON
import PerfectLib

class AppConfig {
    
    var data: JSON
    
    init(json: JSON?) {
        if let json = json {
            data = json
        } else {
            data = JSON.null
        }
    }
    
    func string(forKey key: String) -> String? {
        return data[key].string
    }
    
    func bool(forKey key: String) -> Bool? {
        return data[key].bool
    }
    
    func int(forKey key: String) -> Int? {
        return data[key].int
    }
    
}

let APP_CONFIG: AppConfig = {
    #if os(macOS)
        let configPath = "/Users/enum/Developer/Calatrava/Workspace/runtime/config.json"
    #else
        let currentPath = FileManager.default.currentDirectoryPath
        let configPath = "\(currentPath)/Workspace/runtime/config.json"
    #endif
    let configFile = File.init(configPath)
    let content = (try? configFile.readString()) ?? ""
    return AppConfig.init(json: JSON.init(parseJSON: content))
}()
