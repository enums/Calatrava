//
//  AboutView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class AboutView: PCListView {
    
    override var templateName: String? {
        return "about.html"
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? MessageModel else {
            return nil
        }
        return [
            "_pjango_param_table_Message_ISADMIN": model.admin.intValue == 1 ? 1 : 0
            
        ]
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard let history = PostsHistoryModel.queryObjects() else {
            return nil
        }
        let message = MessageModel.queryObjects() ?? [MessageModel]()
        return [
            "_pjango_param_table_history": history.reversed(),
            "_pjango_param_table_message": message.reversed(),
        ]
    }
    
    override var viewParam: PCViewParam? {
        EventHooks.hookAbout(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
        ]
    }
}
