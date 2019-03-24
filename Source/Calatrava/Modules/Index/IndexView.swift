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
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let name = ConfigModel.getValueForKey(.name) ?? "null"
        let indexMessage = ConfigModel.getValueForKey(.indexMessage) ?? "null"

        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_name": name,
            "_pjango_param_message": indexMessage,
            
            "_pjango_url_posts_list": pjangoUrlReverse(host: WEBSITE_HOST, name: "posts.list") ?? "",
            "_pjango_url_corpus_list": pjangoUrlReverse(host: WEBSITE_HOST, name: "corpus.list") ?? "",
            "_pjango_url_about": pjangoUrlReverse(host: WEBSITE_HOST, name: "about") ?? "",
            "_pjango_url_update": pjangoUrlReverse(host: WEBSITE_HOST, name: "update") ?? "",
            "_pjango_url_data": pjangoUrlReverse(host: WEBSITE_HOST, name: "report.daily.today") ?? "",
            "_pjango_url_modules": pjangoUrlReverse(host: WEBSITE_HOST, name: "modules") ?? "",
        ]
    }
}
