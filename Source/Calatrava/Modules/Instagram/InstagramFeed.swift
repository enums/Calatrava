//
//  InstagramFeed.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/19.
//

import Foundation
import Pjango

class InstagramFeed: PCModel {
    
    override var tableName: String {
        return "InstagramFeed"
    }
    
    var id = PCDataBaseField.init(name: "ID", type: .string, length: 256)
    var name = PCDataBaseField.init(name: "NAME", type: .string, length: 256)
    var full_name = PCDataBaseField.init(name: "FULL_NAME", type: .string, length: 256)
    var bio = PCDataBaseField.init(name: "BIO", type: .string, length: 1024)
    var url = PCDataBaseField.init(name: "URL", type: .string, length: 1024)
    var caption = PCDataBaseField.init(name: "CAPTION", type: .string, length: 1024)
    var head = PCDataBaseField.init(name: "HEAD", type: .string, length: 1024)
    var image = PCDataBaseField.init(name: "IMAGE", type: .string, length: 1024)
    var big_image = PCDataBaseField.init(name: "BIG_IMAGE", type: .string, length: 1024)
    var comment = PCDataBaseField.init(name: "COMMENT", type: .int)
    var love = PCDataBaseField.init(name: "LOVE", type: .int)
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20)
    
    var headSource: String {
        return VPSCURL.toVPSCUROrCacheForInsImage(url: head.strValue) ?? "http:///"
    }
    
    var imageSource: String {
        return VPSCURL.toVPSCUROrCacheForInsImage(url: image.strValue) ?? "http:///"
    }
    
    var bigImageSource: String {
        return VPSCURL.toVPSCUROrCacheForInsImage(url: big_image.strValue) ?? "http:///"
    }
    
    required init() { }
    
    init(userUrl: String, info: InstagramInfo, node: InstagramMediaNode) {
        super.init()
        id.strValue = info.id
        name.strValue = info.username
        full_name.strValue = info.full_name
        bio.strValue = info.biography
        url.strValue = userUrl
        caption.strValue = node.caption
        head.strValue = info.profile_pic_url
        image.strValue = node.thumbnail_src
        big_image.strValue = node.display_src
        comment.intValue = node.comments_count
        love.intValue = node.likes_count
        date.strValue = Date.init(timeIntervalSince1970: TimeInterval(node.date)).stringValue
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            id, name, full_name, bio, url, caption, head, image, big_image, comment, love, date
        ]
    }
}
