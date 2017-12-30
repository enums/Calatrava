//
//  CorpusPostsLoveHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/30.
//

import Foundation
import Pjango

func corpusPostsLoveHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
        guard let postsList = CorpusPostsModel.queryObjects() else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        guard let cpid = Int(req.getUrlParam(key: "cpid") ?? "") else {
            pjangoHttpResponse("AI娘无法识别你的请求哦！")(req, res)
            return
        }
        let tmpPosts = postsList.filter {
            let posts = $0 as! CorpusPostsModel
            return posts.cpid.intValue == cpid
            }.first as? CorpusPostsModel
        guard let posts = tmpPosts else {
            pjangoHttpResponse("目标博文不存在！")(req, res)
            return
        }
        let ip = req.remoteAddress.host
        let key = "\(cpid)@\(ip)"
        guard !corpusPostsLoveDict.contains(key) else {
            pjangoHttpResponse("今天您已经赞过这篇文章啦！")(req, res)
            return
        }
        posts.love.intValue += 1
        guard CorpusPostsModel.updateObject(posts) else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        corpusPostsLoveDict.insert(key)
        pjangoHttpResponse("已经收到你的赞啦！")(req, res)
        EventHooks.hookCorpusPostsLove(req: req, cpid: cpid)
    }
    
}
