//
//  InstagramListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/19.
//

import Foundation
import Pjango
import Pjango_Postman

class InstagramListView: PCListView {
    
    override var templateName: String? {
        return "instagram_list.html"
    }
    
    var displayFeed: [InstagramFeedModel]?
    
    override var listObjectSets: [String : [PCModel]]? {
        defer {
            displayFeed = nil
        }
        return [
            "_pjango_param_table_instagram_feed": displayFeed ?? [],
            "_pjango_param_table_instagram_user": InstagramUserModel.queryObjects() ?? [],
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        if list == "_pjango_param_table_instagram_feed" {
            guard let feed = model as? InstagramFeedModel else {
                return nil
            }
            return [
                "_pjango_param_table_InstagramFeed_IMAGE_SOURCE": feed.imageSource,
                "_pjango_param_table_InstagramFeed_BIG_IMAGE_SOURCE": feed.bigImageSource,
                "_pjango_param_table_InstagramFeed_HEAD_SOURCE": feed.headSource,
            ]
        } else if list == "_pjango_param_table_instagram_user" {
            guard let user = model as? InstagramUserModel else {
                return nil
            }
            if let id = currentRequest?.getUrlParam(key: "id"), id == user.iid.strValue {
                return [
                    "_pjango_param_table_InstagramUser_HEAD_SOURCE": PostmanCURL.instagramImageToPostmanURL(url: user.head.strValue) ?? "http:///",
                    "_pjango_param_table_InstagramUser_WATCH_BUTTON_TEXT": "取消只看TA",
                    "_pjango_param_table_InstagramUser_WATCH_BUTTON_ID": "",
                ]
            } else {
                return [
                    "_pjango_param_table_InstagramUser_HEAD_SOURCE": PostmanCURL.instagramImageToPostmanURL(url: user.head.strValue) ?? "http:///",
                    "_pjango_param_table_InstagramUser_WATCH_BUTTON_TEXT": "只看TA",
                    "_pjango_param_table_InstagramUser_WATCH_BUTTON_ID": user.iid.strValue,
                ]
            }
        } else {
            return nil
        }
    }
    
    override var viewParam: PCViewParam? {
        guard let request = currentRequest else {
            return nil
        }
        guard var filteredFeed = InstagramFeedModel.cacheFeed else {
            return nil
        }
        filteredFeed.sort { (feedA, feedB) -> Bool in
            feedA.date.strValue > feedB.date.strValue
        }
        var page = 1
        if let pageParam = Int(request.getUrlParam(key: "page") ?? ""), pageParam > 0 {
            page = pageParam
        }
        var id = ""
        if let idParam = request.getUrlParam(key: "id"), idParam != "" {
            filteredFeed = filteredFeed.filter { $0.id.strValue == idParam }
            id = idParam
        }
        let eachPageFeedCount = 12
        var insFeed = [InstagramFeedModel].init()
        let begin = eachPageFeedCount * (page - 1)
        let end = eachPageFeedCount * page - 1
        if (begin < filteredFeed.count) {
            let trueEnd = min(filteredFeed.count - 1, end)
            insFeed = Array(filteredFeed[begin..<(trueEnd + 1)])
        }
        displayFeed = insFeed
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let instagramMessage = ConfigModel.getValueForKey(.instagramMessage) ?? "null"
        
        EventHooks.hookInstagram(req: request)
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_url_instagram_list": "instagram.\(WEBSITE_HOST)/list",
            
            "_pjango_param_message": instagramMessage,
            "_pjango_param_param_page": page,
            "_pjango_param_param_id": id,
            "_pjango_param_param_page_total": max(0, filteredFeed.count - 1) / eachPageFeedCount + 1,
            "_pjango_param_param_total_count": filteredFeed.count,
        ]
    }

}
