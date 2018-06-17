//
//  IndexView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class IndexView: PCDetailView {
    
    override var templateName: String? {
        return "index.html"
    }
    
    override var viewParam: PCViewParam? {
        EventHooks.hookIndex(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        let name = ConfigModel.getValueForKey(.name) ?? ""
        let indexMessage = ConfigModel.getValueForKey(.indexMessage) ?? ""

        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_name": name,
            "_pjango_param_message": indexMessage,
            
            "_pjango_url_posts_posts_list": pjangoUrlReverse(host: "posts.\(WEBSITE_HOST)", name: "list") ?? "",
            "_pjango_url_posts_project_list": pjangoUrlReverse(host: "project.\(WEBSITE_HOST)", name: "list") ?? "",
            "_pjango_url_posts_corpus_list": pjangoUrlReverse(host: "corpus.\(WEBSITE_HOST)", name: "list") ?? "",
            "_pjango_url_posts_about": pjangoUrlReverse(host: "\(WEBSITE_HOST)", name: "about") ?? "",
            "_pjango_url_update": pjangoUrlReverse(host: "\(WEBSITE_HOST)", name: "update") ?? "",
            "_pjango_url_instagram_feed": pjangoUrlReverse(host: "instagram.\(WEBSITE_HOST)", name: "feed") ?? "",
            "_pjango_url_bilibili_feed": pjangoUrlReverse(host: "bilibili.\(WEBSITE_HOST)", name: "feed") ?? "",
        ]
    }
}
