//
//  InstagramTimerPlugin.swift
//  Poster
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import Pjango
import SwiftyJSON

class InstagramTimerPlugin: PCTimerPlugin {
    
    override var timerInterval: TimeInterval {
        return 60 * 10
    }
    
    override var task: PCTask? {
        return {
            guard let igs = InstagramUserModel.queryObjects() as? [InstagramUserModel] else {
                return
            }
            let ip = "InstagramTimer"
            let port = "null"
            logger.info("[Instagram] Pull Start!")
            let urls = igs.map { $0.url.strValue }
            for url in urls {
                guard let html = VPSCURL.postCURLRequest(url: url, clientIp: ip, clientPort: port) else {
                    continue
                }
                guard let info = self.buildInstagramInfo(html: html) else {
                    continue
                }
                info.fetch(clientIp: ip, clientPort: port)
                instagramDict[info.id] = info
            }
            logger.info("[Instagram] Pull Done!")
        }
    }
    
    open func buildInstagramInfo(html: String) -> InstagramInfo? {
        guard let jsonBegin = html.range(of: "window._sharedData = ")?.upperBound else {
            return nil
        }
        guard let jsonEnd = html.range(of: "};</script>")?.lowerBound else {
            return nil
        }
        let jsonRange = jsonBegin..<html.index(jsonEnd, offsetBy: 1)
        let subString = html.substring(with: jsonRange)
        let json = JSON.parse(subString)
        return InstagramInfo.init(json: json)
    }
}
