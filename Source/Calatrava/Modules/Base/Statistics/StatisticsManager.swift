//
//  StatisticsManager.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/23.
//

import Foundation
import PerfectHTTP

class StatisticsManager {
    
    static func statisticsEvent(eventType: VisitStatisticsEventType, param: String? = nil, req: HTTPRequest?) {
        let date = Date.init()
        let dateStr = Int(date.timeIntervalSince1970 * 1000)
        let ip = req?.header(.custom(name: "watchdog_ip")) ?? req?.remoteAddress.host ?? "unknow"
        let port = UInt16(req?.header(.custom(name: "watchdog_port")) ?? "") ?? 0
        
        let model = VisitStatisticsModel.init()
        model.vid.strValue = "\(dateStr)@\(ip):\(port)"
        model.date.strValue = date.stringValue
        model.ip.strValue = ip
        model.port.intValue = Int(port)
        model.from.strValue = req?.header(HTTPRequestHeader.Name.referer) ?? ""
        model.event.strValue = eventType.rawValue
        model.param.strValue = param ?? ""
        
        guard VisitStatisticsModel.insertObject(model) else {
            statisticsLogger.error("Failed: [\(ip)][\(port)][\(model.from.strValue)][\(eventType.rawValue)][\(param ?? "")]")
            return
        }
        statisticsLogger.info("Success: [\(ip)][\(port)][\(model.from.strValue)][\(eventType.rawValue)][\(param ?? "")]")
        
    }

}
