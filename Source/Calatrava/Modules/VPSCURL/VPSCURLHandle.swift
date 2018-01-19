//
//  VPSCURLHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import SwiftyJSON
import Pjango

func VPSCURLHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
        guard let nodes = instagramDict["4073270979"]?.mediaNodes else {
            pjangoHttpResponse("ERROR")(req, res)
            return
        }
        let body = nodes.reduce("") { $0 + "[\($1.id)]\n\($1.display_src)\n" }
        pjangoHttpResponse(body)(req, res)
    }
    
}

