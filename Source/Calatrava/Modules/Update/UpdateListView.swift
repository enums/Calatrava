//
//  UpdateListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/18.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

var UpadateListCache: [UpdateModel]?
var UpadateListCacheTime: Date?

class UpdateListView: PCListView {
    
    override var templateName: String? {
        return "update.html"
    }
    
    var displayUpdates: [UpdateModel]?
    
    func generateAllUpdate() -> [UpdateModel] {
        var needRebuild: Bool
        if UpadateListCache != nil, let cacheTime = UpadateListCacheTime {
            if Date.init().timeIntervalSince1970 - cacheTime.timeIntervalSince1970 > 60 {
                needRebuild = true
            } else {
                needRebuild = false
            }
        } else {
            needRebuild = true
        }
        
        var updates = [UpdateModel]();
        if needRebuild {
            if let posts = PostsModel.queryObjects() as? [PostsModel] {
                updates += posts.map { UpdateModel.init($0) }
            }
            
            if let projects = ProjectModel.queryObjects() as? [ProjectModel] {
                updates += projects.map { UpdateModel.init($0) }
            }
            
            if let corpuss = CorpusPostsModel.queryObjects() as? [CorpusPostsModel] {
                updates += corpuss.map { UpdateModel.init($0) }
            }
            
            if let instagrams = InstagramFeedModel.queryObjects() as? [InstagramFeedModel] {
                updates += instagrams.map { UpdateModel.init($0) }
            }
            
            if let bilibilis = BilibiliFeedModel.queryObjects() as? [BilibiliFeedModel] {
                updates += bilibilis.map { UpdateModel.init($0) }
            }
            
            updates.sort(by: { $0.0.date > $0.1.date })
            
            UpadateListCache = updates
            UpadateListCacheTime = Date.init()
        }
        
        return UpadateListCache ?? []
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard let updates = displayUpdates else {
            return nil
        }
        var list1 = [UpdateModel]()
        var list2 = [UpdateModel]()
        for i in 0..<updates.count {
            if i < 6 {
                list1.append(updates[i])
            } else {
                list2.append(updates[i])
            }
        }
        return [
            "_pjango_param_table_update_1": list1,
            "_pjango_param_table_update_2": list2
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? UpdateModel else {
            return nil
        }
        return [
            "_pjango_param_table_update_HTML": model.generateTemplate()
        ]
    }
    
    
    override var viewParam: PCViewParam? {
        guard let req = currentRequest else {
            return nil;
        }
        var updateList = generateAllUpdate();
        
        var page = 1
        if let pageParam = Int(req.getUrlParam(key: "page") ?? ""), pageParam > 0 {
            page = pageParam
        }
        let ignorePostman = Bool(req.getUrlParam(key: "ignore_postman") ?? "") ?? false
        if ignorePostman {
            updateList = updateList.filter { $0.type != .instagram }
        }
        let eachPageFeedCount = 12
        let begin = eachPageFeedCount * (page - 1)
        let end = eachPageFeedCount * page - 1
        var updates = [UpdateModel].init()
        if (begin < updateList.count) {
            let trueEnd = min(updateList.count - 1, end)
            updates = Array(updateList[begin..<(trueEnd + 1)])
        }
        
        displayUpdates = updates

        EventHooks.hookBlogUpdate(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let ignorePostmanButtonTitle = ignorePostman ? "包含 Postman 抓取 Instagram 的动态" : "忽略 Postman 抓取 Instagram 的动态"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_url_update": "\(WEBSITE_HOST)/update",
            
            "_pjango_param_param_page": page,
            "_pjango_param_param_page_total": max(0, updateList.count - 1) / eachPageFeedCount + 1,
            "_pjango_param_param_total_count": updateList.count,
            "_pjango_param_param_ignore_postman": ignorePostman,
            "_pjango_param_param_ignore_postman_button_title": ignorePostmanButtonTitle

        ]
    }
    

}
