//
//  ErrorNotSupportView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/7/1.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ErrorNotSupportView: PCDetailView {
    
    override var templateName: String? {
        return "error_notsupport.html"
    }
    
    override var viewParam: PCViewParam? {
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": ConfigModel.getValueForKey(.titleMessage) ?? "",
            
            "_pjango_param_website_host": WEBSITE_HOST,
        ]
    }
    
}
