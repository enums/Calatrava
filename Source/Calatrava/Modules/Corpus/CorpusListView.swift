//
//  CorpusListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/29.
//

import Foundation
import Pjango

class CorpusListView: PCListView {
    
    override var templateName: String? {
        return "corpus_list.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var corpusList = CorpusModel.queryObjects() as? [CorpusModel] else {
            return nil
        }
        corpusList.sort { $0.updateDate > $1.updateDate }
        return [
            "_pjango_param_table_corpus": corpusList
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? CorpusModel else {
            return nil
        }
        return [
            "_pjango_param_table_Corpus_UPDATEDATE": model.updateDate,
        ]
    }
    
    
    override var viewParam: PCViewParam? {
        EventHooks.hookCorpusList(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_host": WEBSITE_HOST
            
        ]
    }
    
}
