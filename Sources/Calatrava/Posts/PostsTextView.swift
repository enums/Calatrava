//
//  PostsTextView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsTextView: PCDetailView {
    
    var pid: Int
    
    override var templateName: String? {
        return "posts/\(pid).html"
    }
    
    init(pid: Int) {
        self.pid = pid
    }
    
    required init() {
        self.pid = -1
    }
    
}
