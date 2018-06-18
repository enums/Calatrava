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
        
        let postsList = PostsModel.queryObjects() as? [PostsModel] ?? []
        let corpusPostsList = CorpusPostsModel.queryObjects() as? [CorpusPostsModel] ?? []

        let readSum = postsList.reduce(0) {
            $0 + $1.read.intValue
        } + corpusPostsList.reduce(0) {
            $0 + $1.read.intValue
        }
        let loveSum = postsList.reduce(0) {
            $0 + $1.love.intValue
        } + corpusPostsList.reduce(0) {
            $0 + $1.love.intValue
        }
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        let counterIndex = Int(ConfigModel.getValueForKey(.counterIndex) ?? "0") ?? 0
        let counterList = Int(ConfigModel.getValueForKey(.counterPostsList) ?? "0") ?? 0
        let counterSearch = Int(ConfigModel.getValueForKey(.counterPostsSearch) ?? "0") ?? 0
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_counter_posts": postsList.count + corpusPostsList.count,
            "_pjango_param_counter_read": readSum,
            "_pjango_param_counter_love": loveSum,
            "_pjango_param_counter_index": counterIndex,
            "_pjango_param_counter_list": counterList,
            "_pjango_param_counter_search": counterSearch,
            
        ]
    }
}
