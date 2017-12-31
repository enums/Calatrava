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

class PostsView: PCListView {
    
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
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? PostsCommentModel else {
            return nil
        }
        let hasRefer = model.refer_floor.intValue > 0
        if hasRefer, let refer = (PostsCommentModel.queryObjects() as? [PostsCommentModel])?.filter({ $0.pid.intValue == model.pid.intValue && $0.floor.intValue == model.refer_floor.intValue }).first {
            var fields: [String : Any] =  [
                "_pjango_param_table_PostsComment_ISADMIN": model.admin.intValue == 1 ? 1 : 0,
                "_pjango_param_table_PostsComment_HAVE_REFER": 1,
                "_pjango_param_table_PostsComment_REFER_ISADMIN": refer.admin.intValue == 1 ? 1 : 0,
                "_pjango_param_table_PostsComment_REFER_NAME": refer.name.strValue,
                "_pjango_param_table_PostsComment_REFER_DATE": refer.date.strValue,
            ]
            if refer.refer_floor.intValue > 0 {
                fields["_pjango_param_table_PostsComment_REFER_COMMENT"] = "[引用 \(refer.refer_floor.intValue) 楼]\n" + refer.comment.strValue
            } else {
                fields["_pjango_param_table_PostsComment_REFER_COMMENT"] = refer.comment.strValue
            }
            return fields
        } else {
            return [
                "_pjango_param_table_PostsComment_ISADMIN": model.admin.intValue == 1 ? 1 : 0,
                "_pjango_param_table_PostsComment_HAVE_REFER": 0,
                "_pjango_param_table_PostsComment_REFER_ISADMIN": 0,
            ]
        }
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var commentList = PostsCommentModel.queryObjects() as? [PostsCommentModel] else {
            return nil
        }
        commentList = commentList.filter({ $0.pid.intValue == currentPosts?.pid.intValue })
        return [
            "_pjango_param_table_comment": commentList,
        ]
    }
    
    override var viewParam: PCViewParam? {
        guard let posts = currentPosts else {
            return nil
        }
        EventHooks.hookPostsRead(req: currentRequest, pid: posts.pid.intValue)
        
        posts.read.intValue += 1
        PostsModel.updateObject(posts)

        let title = posts.title.strValue
        let pid = posts.pid.intValue
        let tag = posts.tagModel.map { $0.toViewParam() }
        let date = posts.date.strValue
        let read = posts.read.intValue
        let comment = posts.commentsCount
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
            "_pjango_param_posts_comment": comment,
            "_pjango_param_posts_love": love,
            "_pjango_template_posts_text": PostsTextView.init(pid: posts.pid.value as! Int).getTemplate(),
        ]
    }
}
