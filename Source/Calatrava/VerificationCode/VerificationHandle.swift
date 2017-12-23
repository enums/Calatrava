//
//  VerificationHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/23.
//

import Foundation
import Pjango

func verificationHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
        let ip = req.remoteAddress.host
        if let lastTime = verificationLastTimeDict[ip] {
            guard Date.init().timeIntervalSince1970 - lastTime > 10 else {
                logger.info("Verification - Frequency anomaly @ \(ip)")
                pjangoHttpResponse("你请求得太频繁啦！")(req, res)
                return
            }
        }
        let (identifier, question) = VerificationManager.generateCode()
        pjangoHttpResponse("\(question)@\(identifier)")(req, res)
    }
    
}
