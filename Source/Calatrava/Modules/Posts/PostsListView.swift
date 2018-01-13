//
//  PostsListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsListView: PCListView {
        
    override var templateName: String? {
        return "posts_list.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var postsList = PostsModel.queryObjects() else {
            return nil
        }
        if let req = currentRequest {
            var needHooks = false
            if let tag = req.getUrlParam(key: "tag") {
                needHooks = true
                postsList = postsList.filter {
                    let posts = $0 as! PostsModel
                    return (posts.tag.value as! String).components(separatedBy: "|").contains(tag)
                }
            }
            let keyword = req.getUrlParam(key: "keyword")?.lowercased()
            if let keyword = keyword {
                needHooks = true
                postsList = postsList.filter {
                    let posts = $0 as! PostsModel
                    return (posts.title.value as! String).lowercased().contains(keyword) ||
                        (posts.date.value as! String).lowercased().contains(keyword)
                }
            }
            if needHooks {
                EventHooks.hookPostsSearch(req: currentRequest, keyword: keyword)
            } else {
                EventHooks.hookPostsList(req: currentRequest)
            }
        }
        postsList = postsList.reversed().map {
            let posts = $0 as! PostsModel
            posts.date.value = posts.date.strValue.components(separatedBy: " ")[0]

            return posts
        }
        
        return [
            "_pjango_param_table_posts": postsList
        ]

    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? PostsModel else {
            return nil
        }
        return [
            "_pjango_param_table_Posts_TAGHTML": model.tagModel.map { $0.toViewParam() },
            "_pjango_param_table_Posts_COMMENT": model.commentsCount
        ]
    }
    
    
    override var viewParam: PCViewParam? {
        var listTitle = "博文列表"
        if let req = currentRequest {
            let tag = req.getUrlParam(key: "tag")
            let keyword = req.getUrlParam(key: "keyword")
            if tag == nil, keyword == nil {
                listTitle = "全部博文"
            } else if let tag = tag, keyword == nil {
                listTitle = "标签是 `\(tag)` 的博文"
            } else if tag == nil, let keyword = keyword {
                listTitle = "包含 `\(keyword)` 关键字的博文"
            } else if let tag = tag, let keyword = keyword {
                listTitle = "标签是 `\(tag)` 且包含 `\(keyword)` 关键字的博文"
            }
        }
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        let postsListMessage = ConfigModel.getValueForKey(.postsListMessage) ?? ""
        let allTags = PostsTagModel.queryObjects()?.map { $0.toViewParam() } ?? []
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_url_posts_list": "posts.\(WEBSITE_HOST)",
            "_pjango_url_posts_search": "posts.\(WEBSITE_HOST)/search",
            
            "_pjango_param_message": postsListMessage,
            "_pjango_param_list_title": listTitle,
            "_pjango_param_all_tags": allTags
        ]
    }
}
