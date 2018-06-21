//
//  ReportOnlyDateModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation
import Pjango

class ReportOnlyDateModel: PCModel {
    
    var date: String
    var selected = false
    
    init(date: String) {
        self.date = date
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
