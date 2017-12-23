//
//  ProjectListView.swift
//  Pjango-Dev
//
//  Created by 郑宇琦 on 2017/7/1.
//
//

import Foundation
import Pjango

class ProjectListView: PCListView {
    
    override var templateName: String? {
        return "project.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard let projectList = ProjectModel.queryObjects() else {
            return nil
        }
        return [
            "_pjango_param_table_project": projectList.reversed()
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? ProjectModel else {
            return nil
        }
        return [
            "_pjango_param_table_Project_TAGHTML": model.tagModel.map { $0.toViewParam() }
        ]
    }

    
    override var viewParam: PCViewParam? {
        EventHooks.hookProject(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
        ]
    }

}
