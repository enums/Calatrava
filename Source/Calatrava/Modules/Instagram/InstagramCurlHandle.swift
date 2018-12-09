//
//  InstagramCurlHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/20.
//

import Foundation
import PerfectLib
import Pjango
import Pjango_Postman
import SwiftyJSON

enum InstagramCurlAction: String {
    case html = "html"
    case image = "image"
}

func InstagramCurlHandle() -> PCUrlHandle {
    return { req, res in
        guard let encodedStr = req.getUrlParam(key: "value"), let decodedData = encodedStr.decode(.base64url), let decryptedData = PostmanEncryptor.decode(bytes: decodedData), let paramStr = String.init(bytes: decryptedData, encoding: .utf8) else {
            pjangoHttpResponse("")(req, res)
            return
        }
        let json = JSON.init(parseJSON: paramStr)
        guard json != JSON.null else {
            pjangoHttpResponse("")(req, res)
            return
        }
        guard json["key"].string == PostmanConfigModel.pKey else {
            pjangoHttpResponse("")(req, res)
            return
        }
        guard let actionStr = json["action"].string, let action = InstagramCurlAction.init(rawValue: actionStr) else {
            pjangoHttpResponse("")(req, res)
            return
        }
        let ip = req.remoteAddress.host
        let port = "\(req.remoteAddress.port)"
        switch action {
        case .html:
            guard let url = json["url"].string else {
                pjangoHttpResponse("")(req, res)
                return
            }
            guard let bytes = PostmanCURL.getBytes(url: url, clientIp: ip, clientPort: port) else {
                pjangoHttpResponse("")(req, res)
                return
            }
            pjangoHttpResponse(bytes)(req, res)
        case .image:
            guard let url = json["url"].string else {
                pjangoHttpResponse("")(req, res)
                return
            }
            guard let bytes = PostmanCURL.getBytes(url: url, clientIp: ip, clientPort: port) else {
                pjangoHttpResponse("")(req, res)
                return
            }
            if let base64 = Array(url.utf8).digest(.md5)?.encode(.base64url), let filename = String.init(bytes: base64, encoding: .utf8) {
                let path = "\(PJANGO_STATIC_URL)/img/instagram/\(filename).png"
                let file = File.init(path)
                if !file.exists {
                    do {
                        try file.open(.write, permissions: .rxOther)
                        defer {
                            file.close()
                        }
                        try file.write(bytes: bytes)
                        file.close()
                    } catch {
                        logger.error("Cache Image Error![url: \(url)][path: \(path)]")
                    }
                }
            }
            pjangoHttpResponse(bytes)(req, res)
        }
    }
}
