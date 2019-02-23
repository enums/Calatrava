//
//  SearchView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/2/23.
//

import Foundation
import Pjango

class SearchView: PCDetailView {
    
    override var templateName: String? {
        return "search.html"
    }
    
    override var viewParam: PCViewParam? {
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let allTags = (ModuleModel.queryObjects() as? [ModuleModel])?.filter { $0.searchable.intValue > 0 }.map { $0.toViewParam() } ?? []
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_all_tags": allTags,
            
            "_pjango_param_host": WEBSITE_HOST,
        ]
    }
    
}
