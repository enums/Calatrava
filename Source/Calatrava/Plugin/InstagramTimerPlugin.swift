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
        return 60 * 30
    }
    
    override var task: PCTask? {
        return {
            guard let igs = InstagramUserModel.queryObjects() as? [InstagramUserModel] else {
                return
            }
            var insFeed = [InstagramFeed].init()
            logger.info("[Instagram] Pull Start!")
            for user in igs {
                let url = user.url.strValue
                guard let htmlBytes = VPSCURL.getBytes(url: url, clientIp: "Blog", clientPort: "0"), let html = String.init(bytes: htmlBytes, encoding: .ascii) else {
                    continue
                }
                // 频率控制
                Thread.sleep(forTimeInterval: 1)
                guard let info = self.buildInstagramInfo(html: html) else {
                    continue
                }
                user.name.strValue = info.username
                user.full_name.strValue = info.full_name
                user.head.strValue = info.profile_pic_url
                user.bio.strValue = info.biography
                if let first = info.mediaNodes.first {
                    user.updateDate.strValue = Date.init(timeIntervalSince1970: TimeInterval(first.date)).stringValue
                } else {
                    user.updateDate.strValue = "从未"
                }
                InstagramUserModel.updateObject(user)
//                info.fetch()
                info.mediaNodes.forEach({ (node) in
                    let feed = InstagramFeed.init(userUrl: url, info: info, node: node)
                    insFeed.append(feed)
                })
            }
            insFeed.sort(by: { (feedA, feedB) -> Bool in
                feedA.date.strValue > feedB.date.strValue
            })
            
            instagramFeedLock.lock()
            instagramFeed = insFeed
            instagramFeedLock.unlock()
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
