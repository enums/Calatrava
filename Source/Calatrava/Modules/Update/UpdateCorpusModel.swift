//
//  UpdateCorpusView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class UpdateCorpusView: PCDetailView {
    
    var model: CorpusPostsModel
    
    init(model: CorpusPostsModel) {
        self.model = model
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override var templateName: String? {
        return "update_corpus_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        let corpus = ((CorpusModel.queryObjects() as? [CorpusModel])?.filter { $0.cid.intValue == model.cid.intValue })?.first
        let corpusTitle = corpus?.title.strValue ?? "null"
        
        return [
            "_pjango_param_title": model.title.strValue,
            "_pjango_param_corpus_title": corpusTitle,
            "_pjango_param_cid": model.cid.intValue,
            "_pjango_param_cpid": model.cpid.intValue,
            "_pjango_param_date": model.date.strValue,

            "_pjango_url_corpus": "corpus.\(WEBSITE_HOST)",
        ]
    }
    
}
