//
//  HostRedirectFilter.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/3/24.
//

import Foundation
import PerfectHTTP
import Pjango

#if os(macOS)
let WEBSITE_HOST_CORE_OLD = "enumsblogtest.com"
#else
let WEBSITE_HOST_CORE_OLD = "enumsblog.com"
#endif

#if os(macOS)
let WEBSITE_HOST_CORE_NEW = "yuusanntest.com"
#else
let WEBSITE_HOST_CORE_NEW = "yuusann.com"
#endif

class HostRedirectFilter: PCHTTPFilterPlugin {
    
    override func requestFilter(req: HTTPRequest, res: HTTPResponse) -> Bool {
        guard let host = req.header(.host) else {
            return true
        }
        
        if host.contains(string: WEBSITE_HOST_CORE_OLD) {
            req.setHeader(.host, value: host.replacingOccurrences(of: WEBSITE_HOST_CORE_OLD, with: WEBSITE_HOST_CORE_NEW))
        }
        
        return true
    }
    
}
