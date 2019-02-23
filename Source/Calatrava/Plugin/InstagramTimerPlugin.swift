//
//  InstagramTimerPlugin.swift
//  Poster
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import Pjango
import PjangoPostman
import SwiftyJSON

class InstagramTimerPlugin: PCTimerPlugin {
    
    var isLoading = false
    
    override var timerInterval: TimeInterval {
        return 60 * 60 * 3
    }
    
    override var task: PCTask? {
        return {
            guard !self.isLoading else {
                return
            }
            guard let igs = InstagramUserModel.queryObjects() as? [InstagramUserModel] else {
                return
            }
            self.isLoading = true
            defer {
                self.isLoading = false
            }
            logger.info("[Instagram] Pull Start!")
            for user in igs {
                let url = user.url.strValue
                guard let htmlBytes = PostmanCURL.getBytes(url: url, clientIp: "Blog", clientPort: "0"), let html = String.init(bytes: htmlBytes, encoding: .ascii) else {
                    continue
                }
                guard let info = self.buildInstagramInfo(html: html, to: user.updateDate.strValue) else {
                    continue
                }
                user.name.strValue = info.username
                user.full_name.strValue = info.full_name
                user.head.strValue = info.profile_pic_url
                user.bio.strValue = info.biography
                if let first = info.mediaNodes.first {
                    user.updateDate.strValue = Date.init(timeIntervalSince1970: TimeInterval(first.date)).stringValue
                }
                InstagramUserModel.updateObject(user)
                info.mediaNodes.forEach {
                    let node = InstagramFeedModel.init(userUrl: url, info: info, node: $0)
                    InstagramFeedModel.insertObject(node)
                }
            }
            InstagramFeedModel.recache()
            logger.info("[Instagram] Pull Done!")
        }
    }
    
    open func buildInstagramInfo(html: String, to date: String) -> InstagramInfo? {
        guard let jsonBegin = html.range(of: "window._sharedData = ")?.upperBound else {
            return nil
        }
        guard let jsonEnd = html.range(of: "};</script>")?.lowerBound else {
            return nil
        }
        let jsonRange = jsonBegin..<html.index(jsonEnd, offsetBy: 1)
        let subString = String(html[jsonRange])
        let json = JSON.init(parseJSON: subString)
        guard let info = InstagramInfo.init(json: json) else {
            return nil
        }
        info.fetch(to: Int(date.dateValue?.timeIntervalSince1970 ?? 0))
        return info
    }
}
