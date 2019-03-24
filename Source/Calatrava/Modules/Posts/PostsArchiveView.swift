//
//  PostsArchiveView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/18.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class PostsArchiveView: PCListView {
    
    override var templateName: String? {
        return "posts_archive.html"
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var postsList = PostsModel.queryObjects(ext: (true, "ORDER BY date DESC")) as? [PostsModel] else {
            return nil
        }
        postsList = postsList.map { posts in
            posts.date.value = posts.date.strValue.components(separatedBy: " ")[0]
            
            return posts
        }
        
        return [
            "_pjango_param_table_posts": postsList
        ]
    }
    
    override var viewParam: PCViewParam? {
        EventHooks.hookPostsArchive(req: currentRequest)
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_url_host": WEBSITE_HOST,
        ]
    }
}
