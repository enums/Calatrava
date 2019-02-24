//
//  PostsSearchView.swift
//  Pjango-Dev
//
//  Created by 郑宇琦 on 2017/6/27.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsSearchView: PCDetailView {
    
    override var templateName: String? {
        return "posts_search.html"
    }
    
    override var viewParam: PCViewParam? {
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let allTags = PostsTagModel.queryObjects()?.map { $0.toViewParam() } ?? []

        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_all_tags": allTags,
            "_pjango_url_search": pjangoUrlReverse(host: WEBSITE_HOST, name: "search") ?? "",

            "_pjango_param_host": WEBSITE_HOST,
        ]
    }
    
}
