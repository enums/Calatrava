//
//  PostsView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import PerfectHTTP
import Pjango

class PostsView: PCDetailView {
    
    override var templateName: String? {
        return "posts.html"
    }
    
    var currentPosts: PostsModel? = nil
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let req = currentRequest,
              let pidStr = req.urlVariables["pid"],
              let pid = Int(pidStr) else {
                return false
        }
        let models = PostsModel.queryObjects() as! [PostsModel]
        let postsFilterResult = (models).filter {
            ($0.pid.value as! Int) == pid
        }
        guard let posts = postsFilterResult.first else {
            return false
        }
        currentPosts = posts
        return true
    }
    
    override func requestInvaildHandle() -> PCUrlHandle? {
        return pjangoHttpRedirect(name: "error.404")
    }
    
    override var viewParam: PCViewParam? {
        guard let posts = currentPosts else {
            return nil
        }
        currentPosts = nil
        
        posts.read.intValue += 1
        PostsModel.updateObject(posts)

        let title = posts.title.strValue
        let pid = posts.pid.intValue
        let tag = posts.tagModel.map { $0.toViewParam() }
        let date = posts.date.strValue
        let read = posts.read.intValue
        let love = posts.love.intValue
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? ""
        let name = ConfigModel.getValueForKey(.name) ?? ""
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_name": name,

            "_pjango_param_host": WEBSITE_HOST,
            
            "_pjango_param_posts_title": title,
            "_pjango_param_posts_pid": pid,
            "_pjango_param_posts_tag": tag,
            "_pjango_param_posts_date": date,
            "_pjango_param_posts_read": read,
            "_pjango_param_posts_love": love,
            "_pjango_template_posts_text": PostsTextView.init(pid: posts.pid.value as! Int).getTemplate()
        ]
    }
}
