//
//  PostsLoveHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

func postsLoveHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
        guard let postsList = PostsModel.queryObjects() else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        guard let pid = Int(req.getUrlParam(key: "pid") ?? "") else {
            pjangoHttpResponse("AI娘无法识别你的请求哦！")(req, res)
            return
        }
        let tmpPosts = postsList.filter {
            let posts = $0 as! PostsModel
            return posts.pid.intValue == pid
        }.first as? PostsModel
        guard let posts = tmpPosts else {
            pjangoHttpResponse("目标博文不存在！")(req, res)
            return
        }
        let ip = req.remoteAddress.host
        let key = "\(pid)@\(ip)"
        guard !postsLoveDict.contains(key) else {
            pjangoHttpResponse("今天您已经赞过这篇博文啦！")(req, res)
            return
        }
        guard PostsModel.updateObject(posts) else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        posts.love.intValue += 1
        postsLoveDict.insert(key)
        pjangoHttpResponse("已经收到你的赞啦！")(req, res)
        EventHooks.hookPostsLove(req: req, pid: pid)
    }

}

