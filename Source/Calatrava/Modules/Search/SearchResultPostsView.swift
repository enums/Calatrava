//
//  SearchResultPostsView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/2/23.
//

import Foundation
import Pjango

class SearchResultPostsView: PCDetailView {
    
    var model: PostsModel?
    
    init(model: PostsModel) {
        self.model = model
    }
    
    required init() {
        
    }
    
    override var templateName: String? {
        return "search_result_posts_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        guard let model = model else {
            return nil
        }
        return [
            "_pjango_param_title": model.title.strValue,
            "_pjango_param_pid": model.pid.intValue,
            "_pjango_param_date": model.date.strValue,
            "_pjango_param_table_tag": model.tagModel.map { $0.toViewParam() },
            
            "_pjango_url_index": WEBSITE_HOST,
            "_pjango_url_posts": "posts.\(WEBSITE_HOST)",
        ]
    }
    
}
