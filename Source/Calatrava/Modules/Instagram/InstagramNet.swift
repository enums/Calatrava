//
//  InstagramNet.swift
//  Poster
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import SwiftyJSON
import PerfectLib
import Pjango

class InstagramMediaNode {
    
    let typename: String
    let id: String
    let caption: String
    let thumbnail_src: String
    let display_src: String
    let comments_count: Int
    let likes_count: Int
    let date: Int64
    
    init?(json: JSON) {
        guard let typename = json["__typename"].string else {
            return nil
        }
        guard let id = json["id"].string else {
            return nil
        }
        var captionStr = json["caption"].string
        if captionStr == nil {
            if let edgesArray = json["edge_media_to_caption"]["edges"].array, edgesArray.count > 0 {
                captionStr = edgesArray[0]["node"]["text"].string
            } else {
                captionStr = ""
            }
        }
        guard let caption = captionStr else {
            return nil
        }
        guard let thumbnail_src = json["thumbnail_src"].string else {
            return nil
        }
        
        var display = json["display_src"].string
        if display == nil {
            display = json["display_url"].string
        }
        guard let display_src = display else {
            return nil
        }
        
        var takeDate = json["date"].int64
        if takeDate == nil {
            takeDate = json["taken_at_timestamp"].int64
        }
        guard let date = takeDate else {
            return nil
        }
        
        var comments_count = json["comments"]["count"].int
        if comments_count == nil {
            comments_count = json["edge_media_to_comment"]["count"].int
        }
        guard let commentCount = comments_count else {
            return nil
        }
        
        var likes_count = json["likes"]["count"].int
        if likes_count == nil {
            likes_count = json["edge_media_preview_like"]["count"].int
        }
        guard let likeCount = likes_count else {
            return nil
        }
        
        self.typename = typename
        self.id = id
        self.caption = caption
        self.thumbnail_src = thumbnail_src
        self.display_src = display_src
        self.comments_count = commentCount
        self.likes_count = likeCount
        self.date = date
    }

}

class InstagramInfo {
    
    let id: String
    let username: String
    let profile_pic_url: String
    let full_name: String
    let biography: String
    var mediaNodes: [InstagramMediaNode]
    var end_cursor: String
    
    init?(json: JSON) {
        guard let profilePageJson = json["entry_data"]["ProfilePage"].array, profilePageJson.count > 0 else {
            return nil
        }
        let userJson = profilePageJson[0]["user"]
        guard let username = userJson["username"].string else {
            return nil
        }
        guard let full_name = userJson["full_name"].string else {
            return nil
        }
        guard let biography = userJson["biography"].string else {
            return nil
        }
        guard let profile_pic_url = userJson["profile_pic_url"].string else {
            return nil
        }
        guard let id = userJson["id"].string else {
            return nil
        }
        let mediaJson = userJson["media"]
        guard let nodesJson = mediaJson["nodes"].array else {
            return nil
        }
        let nodes = nodesJson.flatMap { InstagramMediaNode.init(json: $0) }
        guard let end_cursor = mediaJson["page_info"]["end_cursor"].string else {
            return nil
        }
        
        self.id = id
        self.username = username
        self.profile_pic_url = profile_pic_url
        self.full_name = full_name
        self.biography = biography
        self.mediaNodes = nodes
        self.end_cursor = end_cursor
    }
    
    func fetch() {
        while let url = nextURL() {
            guard let json = VPSCURL.instagramFetch(url: url, clientIp: "Blog", clientPort: "0") else {
                return
            }
            let edgeJson = json["data"]["user"]["edge_owner_to_timeline_media"]
            guard let nodesJson = edgeJson["edges"].array else {
                return
            }
            let nodes = nodesJson.flatMap { InstagramMediaNode.init(json: $0["node"]) }
            mediaNodes.append(contentsOf: nodes)
            if let end_cursor = edgeJson["page_info"]["end_cursor"].string {
                self.end_cursor = end_cursor
            } else {
                self.end_cursor = ""
            }
        }

    }
    
    func nextURL() -> String? {
        guard end_cursor != "" else {
            return nil
        }
        let variables = [
            "id": id,
            "first": "12",
            "after": end_cursor,
            ]
        guard let variablesStr = JSON.init(variables).description.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return "https://www.instagram.com/graphql/query/?query_id=17888483320059182&variables=\(variablesStr)"
    }
}

extension VPSCURL {
    
    static func instagramImageToVPSCURL(url: String) -> String? {
        let param = [
            "key": VPSCURLKey,
            "action": InstagramCurlAction.image.rawValue,
            "url": url,
            ]
        if let base64 = Array(url.utf8).digest(.md5)?.encode(.base64url), let filename = String.init(bytes: base64, encoding: .utf8) {
            let path = "\(PJANGO_STATIC_URL)/img/instagram/\(filename).png"
            let file = File.init(path)
            if (file.exists) {
                return "http://instagram.\(WEBSITE_HOST)/img/instagram/\(filename).png"
            }
        }
        return toVPSCUR(base: "instagram.\(WEBSITE_HOST)/resource", param: param)
    }
    
    // 包含频率控制，如果失败了就等待600秒继续。
    fileprivate static func instagramFetch(url: String, clientIp: String, clientPort: String) -> JSON? {
        var json = JSON.null
        var isFirst = true
        while json["status"].string != "ok" {
            if (!isFirst) {
                logger.info("[Instagram] Request Rate Limited Sleep Triggered!")
                Thread.sleep(forTimeInterval: 600)
                logger.info("[Instagram] Request Rate Retry!")
            }
            isFirst = false
            guard let html = VPSCURL.getString(url: url, clientIp: "Blog", clientPort: "0") else {
                return nil
            }
            json = JSON.parse(html)
            guard json.type != .null else {
                return nil
            }
        }
        return json
    }
}
