//
//  UpdatePostsView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class UpdatePostsView: PCDetailView {
    
    var model: PostsModel
    
    init(model: PostsModel) {
        self.model = model
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override var templateName: String? {
        return "update_posts_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        return [
            "_pjango_param_title": model.title.strValue,
            "_pjango_param_pid": model.pid.intValue,
            "_pjango_param_date": model.date.strValue,
            
            "_pjango_url_index": "\(WEBSITE_HOST)",
            "_pjango_url_posts_list": "posts.\(WEBSITE_HOST)",
        ]
    }
    
}
