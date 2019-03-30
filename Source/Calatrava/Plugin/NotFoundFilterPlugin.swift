//
//  NotFoundFilterPlugin.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import PerfectHTTP
import Pjango

class NotFoundFilterPlugin: PCHTTPFilterPlugin {
    
    override func responseFilterHeader(req: HTTPRequest, res: HTTPResponse) -> Bool {
        if case .notFound = res.status {
            ErrorNotFoundView.asHandle()(req, res)
            return false
        } else {
            return true
        }
        
    }
    
}
