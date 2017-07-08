//
//  AboutView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class AboutView: PCListView {
    
    override var templateName: String? {
        return "about.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard let objs = PostsHistoryModel.queryObjects() else {
            return nil
        }
        return [
            "_pjango_param_table_history": objs.reversed(),
        ]
    }
    
    override var viewParam: PCViewParam? {
        
        let postsList = PostsModel.queryObjects() ?? []
        
        let readSum = postsList.reduce(0) {
            let posts = $1 as! PostsModel
            return $0 + posts.read.intValue
        }
        let loveSum = postsList.reduce(0) {
            let posts = $1 as! PostsModel
            return $0 + posts.love.intValue
        }
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        
        let counterIndex = Int(ConfigModel.getValueForKey(.counterIndex) ?? "0") ?? 0
        let counterList = Int(ConfigModel.getValueForKey(.counterPostsList) ?? "0") ?? 0
        let counterSearch = Int(ConfigModel.getValueForKey(.counterPostsSearch) ?? "0") ?? 0
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_counter_posts": postsList.count,
            "_pjango_param_counter_read": readSum,
            "_pjango_param_counter_love": loveSum,
            "_pjango_param_counter_index": counterIndex,
            "_pjango_param_counter_list": counterList,
            "_pjango_param_counter_search": counterSearch,
            
        ]
    }
}
