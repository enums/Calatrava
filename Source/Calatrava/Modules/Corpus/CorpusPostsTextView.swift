//
//  CorpusPostsTextView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/30.
//

import Foundation
import Pjango

class CorpusTextView: PCDetailView {
    
    var cpid: Int
    
    override var templateName: String? {
        return "corpus/\(cpid).html"
    }
    
    init(cpid: Int) {
        self.cpid = cpid
    }
    
    required init() {
        self.cpid = -1
    }
    
}
