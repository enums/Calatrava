//
//  ModuleListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/12/6.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ModuleListView: PCListView {
    
    override var templateName: String? {
        return "modules.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard let moduleList = ModuleModel.queryObjects() else {
            return nil
        }
        return [
            "_pjango_param_table_module": moduleList
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? ModuleModel else {
            return nil
        }
        return [
            "_pjango_param_table_Module_REALURL": model.realUrl
        ]
    }
    
    override var viewParam: PCViewParam? {
        EventHooks.hookModuleList(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let name = ConfigModel.getValueForKey(.name) ?? "null"
        let indexMessage = ConfigModel.getValueForKey(.indexMessage) ?? "null"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_name": name,
            "_pjango_param_message": indexMessage,
        ]
    }
}

