//
//  FooterBarView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class FooterBarView: PCDetailView {
    
    override var templateName: String? {
        return "footer_bar.html"
    }
    
    static var html = FooterBarView.meta.getTemplate()
}
