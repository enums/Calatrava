//
//  HostRedirectFilter.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/3/24.
//

import Foundation
import PerfectHTTP
import Pjango

class HostRedirectFilter: PCHTTPFilterPlugin {
    
    override func requestFilter(req: HTTPRequest, res: HTTPResponse) -> Bool {
        guard let host = req.header(.host) else {
            return true
        }
        
        if host.contains(string: WEBSITE_HOST_OLD) {
            req.setHeader(.host, value: host.replacingOccurrences(of: WEBSITE_HOST_OLD, with: WEBSITE_HOST))
        }
        
        return true
    }
    
}
