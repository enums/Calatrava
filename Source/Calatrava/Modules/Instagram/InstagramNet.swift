//
//  InstagramNet.swift
//  Poster
//
//  Created by 郑宇琦 on 2018/1/18.
//

import Foundation
import SwiftyJSON

class InstagramMediaNode {
    
    let typename: String
    let id: String
    let thumbnail_src: String
    let display_src: String
    let date: Int64
    
    init?(json: JSON) {
        guard let typename = json["__typename"].string else {
            return nil
        }
        guard let id = json["id"].string else {
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
        
        self.typename = typename
        self.id = id
        self.thumbnail_src = thumbnail_src
        self.display_src = display_src
        self.date = date
    }

}

class InstagramInfo {
    
    let id: String
    let full_name: String
    let biography: String
    var mediaNodes: [InstagramMediaNode]
    var end_cursor: String
    
    init?(json: JSON) {
        guard let profilePageJson = json["entry_data"]["ProfilePage"].array, profilePageJson.count > 0 else {
            return nil
        }
        let userJson = profilePageJson[0]["user"]
        guard let full_name = userJson["full_name"].string else {
            return nil
        }
        guard let biography = userJson["biography"].string else {
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
        self.full_name = full_name
        self.biography = biography
        self.mediaNodes = nodes
        self.end_cursor = end_cursor
    }
    
    func fetch(clientIp: String, clientPort: String) {
        while let url = nextURL() {
            guard let html = VPSCURL.postCURLRequest(url: url, clientIp: clientIp, clientPort: clientPort) else {
                continue
            }
            let json = JSON.parse(html)
            guard json != JSON.null else {
                continue
            }
            let edgeJson = json["data"]["user"]["edge_owner_to_timeline_media"]
            guard let nodesJson = edgeJson["edges"].array else {
                continue
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
