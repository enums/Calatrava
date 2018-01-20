//
//  VPSSSCURL.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/19.
//

import Foundation
import Dispatch
import SwiftyJSON
import PerfectCURL
import cURL

class VPSSSCURL {
    
    static func get(url: String) -> [UInt8] {
        
        let curl = CURL(url: url)
        curl.setOption(CURLOPT_PROXYTYPE, int: Int(CURLPROXY_SOCKS5.rawValue))
        curl.setOption(CURLOPT_PROXY, s: "socks5h://127.0.0.1:1080");
        
        let (_, _, resBody) = curl.performFully()
        
        return resBody
    }
    
    static func toVPSSSCURL(url: String) -> String? {
        return "http://\(WEBSITE_HOST)/vpssscurl?url=\(url.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"
    }
}
