//
//  InstagramFeedModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/1/19.
//

import Foundation
import Pjango
import Pjango_Postman

class InstagramFeedModel: PCModel {
    
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
    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 20)
    
    var headSource: String {
        return PostmanCURL.instagramImageToPostmanURL(url: head.strValue) ?? "http:///"
    }
    
    var imageSource: String {
        return PostmanCURL.instagramImageToPostmanURL(url: image.strValue) ?? "http:///"
    }
    
    var bigImageSource: String {
        return PostmanCURL.instagramImageToPostmanURL(url: big_image.strValue) ?? "http:///"
    }
    
    static var cacheFeed: [InstagramFeedModel]? = InstagramFeedModel.queryObjects(ext: (true, "ORDER BY date DESC")) as? [InstagramFeedModel]
    
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
        date.strValue = Date.init(timeIntervalSince1970: TimeInterval(node.date)).stringValue
    }
    
    override func registerFields() -> [PCDataBaseField] {
        return [
            id, name, full_name, bio, url, caption, head, image, big_image, date
        ]
    }
    
    override class var cacheTime: TimeInterval? {
        return 60 * 15
    }
    
    static func recache() {
        cacheFeed = nil
        guard let feed = InstagramFeedModel.queryObjects(ext: (true, "ORDER BY date DESC")) as? [InstagramFeedModel] else {
            return
        }
        cacheFeed = feed
    }
}
