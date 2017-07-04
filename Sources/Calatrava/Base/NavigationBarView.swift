//
//  NavigationBarView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class NavigationBarView: PCDetailView {
    
    override var templateName: String? {
        return "navigation_bar.html"
    }
    
    override var viewParam: PCViewParam? {
        return [
            "_pjango_param_host": WEBSITE_HOST,
        ]
    }
    
    static var html = NavigationBarView.meta.getTemplate()
    
}
