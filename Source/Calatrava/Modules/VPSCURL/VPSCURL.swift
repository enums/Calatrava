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

let VPSCURLKey = ""

class VPSCURL {
    
    static func toVPSCUR(base: String, param: Dictionary<String, String>) -> String? {
        let paramStr = JSON.init(param).description.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        
        guard let paramBytes = VPSCURLEncryptor.encode(str: paramStr) else {
            return nil
        }
        guard let encodedParamData = paramBytes.encode(.base64url), let encodedParam = String.init(bytes: encodedParamData, encoding: .utf8) else {
            return nil
        }
        return "http://\(base)?value=\(encodedParam)"
    }
    
    static func getString(url: String, clientIp: String, clientPort: String) -> String? {
        guard let bytes = getBytes(url: url, clientIp: clientIp, clientPort: clientPort) else {
            return nil
        }
        return String(validatingUTF8: bytes)
    }
    
    static func getBytes(url: String, clientIp: String, clientPort: String) -> [UInt8]? {
        let vpsUrl = ""
        let body = [
            "method": "GET",
            "key": VPSCURLKey,
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
