//
//  UpdateProjectView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class UpdateProjectView: PCDetailView {
    
    var model: ProjectModel
    
    init(model: ProjectModel) {
        self.model = model
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override var templateName: String? {
        return "update_project_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        return [
            "_pjango_param_title": model.title.strValue,
            "_pjango_param_sub_title": model.subtitle.strValue,
            "_pjango_param_memo": model.memo.strValue,
            "_pjango_param_url": model.url.strValue,
            "_pjango_param_date": model.date.strValue,
            "_pjango_param_table_TAGHTML": model.tagModel.map { $0.toViewParam() }
        ]
    }
    
}
