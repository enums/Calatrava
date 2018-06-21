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
    
    var displayPosts: [PostsModel]?
    
    override var listObjectSets: [String : [PCModel]]? {
        return [
            "_pjango_param_table_posts": displayPosts ?? []
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
        guard let req = currentRequest, var postsList = PostsModel.queryObjects(ext: (true, "ORDER BY date DESC")) as? [PostsModel] else {
            return nil;
        }
        
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
        
        var needHooks = false
        if let tag = tag {
            needHooks = true
            postsList = postsList.filter { posts in
                return (posts.tag.value as! String).components(separatedBy: "|").contains(tag)
            }
        }
        if let keyword = keyword?.lowercased() {
            needHooks = true
            postsList = postsList.filter { posts in
                return (posts.title.value as! String).lowercased().contains(keyword) ||
                    (posts.date.value as! String).lowercased().contains(keyword)
            }
        }
        if needHooks {
            EventHooks.hookPostsSearch(req: currentRequest, keyword: keyword)
        } else {
            EventHooks.hookPostsList(req: currentRequest)
        }
        
        var page = 1
        if let pageParam = Int(req.getUrlParam(key: "page") ?? ""), pageParam > 0 {
            page = pageParam
        }
        let eachPageFeedCount = 12
        let begin = eachPageFeedCount * (page - 1)
        let end = eachPageFeedCount * page - 1
        var posts = [PostsModel].init()
        if (begin < postsList.count) {
            let trueEnd = min(postsList.count - 1, end)
            posts = Array(postsList[begin..<(trueEnd + 1)])
        }
        displayPosts = posts

        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        let postsListMessage = ConfigModel.getValueForKey(.postsListMessage) ?? "null"
        let allTags = PostsTagModel.queryObjects()?.map { $0.toViewParam() } ?? []
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_url_posts_list": "posts.\(WEBSITE_HOST)",
            "_pjango_url_posts_search": "posts.\(WEBSITE_HOST)/search",
            "_pjango_url_posts_archive": "posts.\(WEBSITE_HOST)/archive",
            
            "_pjango_param_message": postsListMessage,
            "_pjango_param_list_title": listTitle,
            "_pjango_param_all_tags": allTags,
            "_pjango_param_param_page": page,
            "_pjango_param_param_page_total": max(0, postsList.count - 1) / eachPageFeedCount + 1,
            "_pjango_param_param_total_count": postsList.count,
            "_pjango_param_param_tag": tag ?? "",
            "_pjango_param_param_keyword": keyword ?? "",

        ]
    }
}
