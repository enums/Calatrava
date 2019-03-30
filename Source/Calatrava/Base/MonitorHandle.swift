//
//  MonitorHandle.swift
//  Calatrava
//
//  Created by enum on 2019/3/26.
//

import Foundation
import Pjango

func monitorHandle() -> PCUrlHandle {
    return pjangoHttpResponse { req, res in
        pjangoHttpResponse("1")(req, res)
    }
}
