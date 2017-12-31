//
//  CorpusPostsView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/30.
//

import Foundation
import PerfectHTTP
import Pjango

class CorpusPostsView: PCListView {
    
    override var templateName: String? {
        return "corpus_posts.html"
    }
    
    var currentPosts: CorpusPostsModel? = nil
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let req = currentRequest,
            let cpidStr = req.urlVariables["cpid"],
            let cpid = Int(cpidStr) else {
                return false
        }
        let models = CorpusPostsModel.queryObjects() as! [CorpusPostsModel]
        let postsFilterResult = (models).filter {
            ($0.cpid.value as! Int) == cpid
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
        guard let model = model as? CorpusPostsCommentModel else {
            return nil
        }
        let hasRefer = model.refer_floor.intValue > 0
        if hasRefer, let refer = (CorpusPostsCommentModel.queryObjects() as? [CorpusPostsCommentModel])?.filter({ $0.cpid.intValue == model.cpid.intValue && $0.floor.intValue == model.refer_floor.intValue }).first {
            var fields: [String : Any] =  [
                "_pjango_param_table_CorpusPostsComment_HAVE_REFER": 1,
                "_pjango_param_table_CorpusPostsComment_REFER_NAME": refer.name.strValue,
                "_pjango_param_table_CorpusPostsComment_REFER_DATE": refer.date.strValue,
                ]
            if refer.refer_floor.intValue > 0 {
                fields["_pjango_param_table_CorpusPostsComment_REFER_COMMENT"] = "[引用 \(refer.refer_floor.intValue) 楼]\n" + refer.comment.strValue
            } else {
                fields["_pjango_param_table_CorpusPostsComment_REFER_COMMENT"] = refer.comment.strValue
            }
            return fields
        } else {
            return [
                "_pjango_param_table_CorpusPostsComment_HAVE_REFER": 0,
            ]
        }
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var commentList = CorpusPostsCommentModel.queryObjects() as? [CorpusPostsCommentModel] else {
            return nil
        }
        commentList = commentList.filter({ $0.cpid.intValue == currentPosts?.cpid.intValue })
        return [
            "_pjango_param_table_comment": commentList,
        ]
    }
    
    override var viewParam: PCViewParam? {
        guard let posts = currentPosts else {
            return nil
        }
        EventHooks.hookCorpusPostsRead(req: currentRequest, cpid: posts.cpid.intValue)
        
        posts.read.intValue += 1
        CorpusPostsModel.updateObject(posts)
        
        let title = posts.title.strValue
        let cpid = posts.cpid.intValue
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
            "_pjango_param_posts_cpid": cpid,
            "_pjango_param_posts_date": date,
            "_pjango_param_posts_read": read,
            "_pjango_param_posts_comment": comment,
            "_pjango_param_posts_love": love,
            "_pjango_template_posts_text": CorpusTextView.init(cpid: posts.cpid.value as! Int).getTemplate(),
        ]
    }
}
