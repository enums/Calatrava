//
//  VPSCURL.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import Dispatch
import SwiftyJSON
import PerfectCURL
import cURL

class VPSCURL {
    
    static func postCURLRequest(url: String, clientIp: String, clientPort: String) -> String? {
        let vpsUrl = ""
        let body = [
            "method": "GET",
            "key": "",
            "client_ip": clientIp,
            "client_port": clientPort,
            "url": url
        ]
        guard let bodyEncrypted = VPSCURLEncryptor.encode(str: JSON.init(body).description) else {
            logger.error("[VPSCURL ERROR][Encrypted failed: \(url)]")
            return nil
        }
        
        let curl = CURL(url: vpsUrl)
        
        curl.setOption(CURLOPT_POST, int: 1)
        curl.setOption(CURLOPT_POSTFIELDS, v: UnsafeMutableRawPointer(mutating: bodyEncrypted))
        curl.setOption(CURLOPT_POSTFIELDSIZE, int: bodyEncrypted.count)
        
        let (_, _, resBody) = curl.performFully()

        return VPSCURLEncryptor.decode(bytes: resBody)
    }
}
