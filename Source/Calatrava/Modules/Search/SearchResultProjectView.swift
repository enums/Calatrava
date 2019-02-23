//
//  SearchResultProjectView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/2/24.
//

import Foundation
import Pjango

class SearchResultProjectView: PCDetailView {
    
    var model: ProjectModel?
    
    init(model: ProjectModel) {
        self.model = model
    }
    
    required init() {
        
    }
    
    override var templateName: String? {
        return "search_result_project_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        guard let model = model else {
            return nil
        }
        return [
            "_pjango_param_title": model.title.strValue,
            "_pjango_param_subtitle": model.subtitle.strValue,
            "_pjango_param_memo": model.memo.strValue,
            "_pjango_param_url": model.url.strValue,
            "_pjango_param_date": model.date.strValue,
            "_pjango_param_table_TAGHTML": model.tagModel.map { $0.toViewParam() }
        ]
    }
    
}
