//
//  CorpusPostsListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/29.
//

import Foundation
import PerfectHTTP
import Pjango

class CorpusPostsListView: PCListView {
    
    override var templateName: String? {
        return "corpus_posts_list.html"
    }
    
    var currentCID: Int? = nil
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let cid = Int(req.urlVariables["cid"] ?? "") else {
            return false
        }
        currentCID = cid
        return true
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var postsList = CorpusPostsModel.queryObjects() as? [CorpusPostsModel], let cid = currentCID else {
            return nil
        }
        postsList = postsList.filter({
            $0.cid.intValue == cid
        }).reversed()
        return [
            "_pjango_param_table_corpus": postsList
        ]
        
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? CorpusPostsModel else {
            return nil
        }
        return [
            "_pjango_param_table_CorpusPosts_COMMENT": model.commentsCount
        ]
    }
    
    
    override var viewParam: PCViewParam? {
        EventHooks.hookCorpusPostsList(req: currentRequest, cid: currentCID ?? -1)

        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        let corpusModel = (CorpusModel.queryObjects() as? [CorpusModel])?.filter {
            $0.cid.intValue == currentCID
        }.first
        let postsListMessage = corpusModel?.memo.strValue ?? ""
        let postsListTitle = corpusModel?.title.strValue ?? ""

        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_url_corpus_posts_list": "corpus.\(WEBSITE_HOST)",
            
            "_pjango_param_message": postsListMessage,
            "_pjango_param_list_title": postsListTitle,
        ]
    }
}
