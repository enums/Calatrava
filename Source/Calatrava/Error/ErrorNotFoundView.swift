//
//  ErrorNotFoundView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ErrorNotFoundView: PCDetailView {
    
    override var templateName: String? {
        return "error_404.html"
    }
    
    let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"

    override var viewParam: PCViewParam? {
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_website_host": WEBSITE_HOST,
        ]
    }
    
}
