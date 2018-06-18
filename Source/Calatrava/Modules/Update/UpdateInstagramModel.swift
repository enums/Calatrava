//
//  UpdateInstagramView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class UpdateInstagramView: PCDetailView {
    
    var model: InstagramFeedModel
    
    init(model: InstagramFeedModel) {
        self.model = model
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override var templateName: String? {
        return "update_instagram_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        return [
            "_pjango_param_author_name": model.name.strValue,
            "_pjango_param_author_fullname": model.full_name.strValue,
            "_pjango_param_author_head": model.headSource,
            "_pjango_param_image": model.imageSource,
            "_pjango_param_image_origin": model.bigImageSource,
            "_pjango_param_caption": model.caption.strValue,
            "_pjango_param_date": model.date.strValue,
        ]
    }
    
}
