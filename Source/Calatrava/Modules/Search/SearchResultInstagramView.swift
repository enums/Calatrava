//
//  SearchResultInstagramView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/2/23.
//

import Foundation
import Pjango

class SearchResultInstagramView: PCDetailView {
    
    var model: InstagramFeedModel?
    
    init(model: InstagramFeedModel) {
        self.model = model
    }
    
    required init() {
        
    }
    
    override var templateName: String? {
        return "search_result_instagram_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        guard let model = model else {
            return nil
        }
        return [
            "_pjango_param_author_name": model.name.strValue,
            "_pjango_param_author_fullname": model.full_name.strValue,
            "_pjango_param_author_head": model.headSource,
            "_pjango_param_author_url": model.url.strValue,
            "_pjango_param_image": model.imageSource,
            "_pjango_param_image_origin": model.bigImageSource,
            "_pjango_param_caption": model.caption.strValue,
            "_pjango_param_date": model.date.strValue,
        ]
    }
    
}
