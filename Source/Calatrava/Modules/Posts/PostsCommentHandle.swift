//
//  PostsCommentHandle.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/20.
//

import Foundation
import Pjango
import SwiftyJSON

func postsCommentHandle() -> PCUrlHandle {
    
    func processRefer(comment: inout String, posts: PostsModel) -> Int {
        guard let begin = comment.range(of: "!*<引用 ")?.upperBound else {
            return 0
        }
        guard let end = comment.range(of: " 楼>*!")?.lowerBound, let endUpper = comment.range(of: " 楼>*!")?.upperBound else {
            return 0
        }
        if let floor = Int(comment[begin..<end]), floor <= posts.commentsCount {
            comment = String(comment.suffix(from: endUpper))
            if comment.first == "\n" {
                comment = String(comment.dropFirst())
            }
            return floor
        } else {
            return 0
        }
    }
    
    return pjangoHttpResponse { req, res in
        guard let postsList = PostsModel.queryObjects() as? [PostsModel] else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        guard let jsonStr = req.postBodyString else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
            return
        }
        let json = JSON.init(parseJSON: jsonStr)
        guard json != JSON.null else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
            return
        }
        guard let v_id = json["v_id"].string, let v_a = json["v_a"].string else {
            pjangoHttpResponse("人机校验失败啦！")(req, res)
            return
        }
        guard VerificationManager.checkCode(identifier: v_id, answer: v_a) else {
            pjangoHttpResponse("人机校验失败啦！")(req, res)
            return
        }
        guard let pid = json["pid"].int, let name = json["name"].string, let email = json["email"].string, var comment = json["comment"].string else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
            return
        }
        guard let tmpPosts = postsList.first(where: { $0.pid.intValue == pid }) else {
            pjangoHttpResponse("目标博文不存在！")(req, res)
            return
        }
        guard name.count > 2 else {
            pjangoHttpResponse("昵称太短啦！")(req, res)
            return
        }
        guard email.contains(string: "@"), email.contains(string: "."), email.count > 5 else {
            pjangoHttpResponse("邮箱地址不合法！")(req, res)
            return
        }
        let refer = processRefer(comment: &comment, posts: tmpPosts)
        guard comment.count > 2 else {
            pjangoHttpResponse("评论太短啦！")(req, res)
            return
        }
        let ip = req.header(.custom(name: "watchdog_ip")) ?? req.remoteAddress.host
        if let lastTime = postsCommentLastTimeDict[ip] {
            guard Date.init().timeIntervalSince1970 - lastTime > 1 else {
                logger.info("Comment - Frequency anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
                pjangoHttpResponse("你提交得太频繁啦！")(req, res)
                return
            }
        }
        postsCommentLastTimeDict[ip] = Date.init().timeIntervalSince1970
        if let count = postsCommentDailyDict[ip] {
            postsCommentDailyDict[ip] = count + 1
        } else {
            postsCommentDailyDict[ip] = 1
        }
        if let count = postsCommentDailyDict[ip], count >= 960 {
            logger.info("Comment - Quantity anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
            pjangoHttpResponse("今天提交的次数已达上限啦！")(req, res)
            return
        }
        
        let date = Date.init().stringValue
        let commentModel = PostsCommentModel.init()
        commentModel.pcid.strValue = "\(pid)_\(name)#\(date)@\(ip)"
        commentModel.pid.intValue = pid
        commentModel.floor.intValue = tmpPosts.commentsCount + 1
        commentModel.refer_floor.intValue = refer
        commentModel.admin.intValue = 0
        commentModel.date.strValue = date
        commentModel.name.strValue = name
        commentModel.email.strValue = email
        commentModel.comment.strValue = comment
        commentModel.fromIp.strValue = ip
        guard PostsCommentModel.insertObject(commentModel) else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        pjangoHttpResponse("发表成功！")(req, res)
        EventHooks.hookPostsComment(req: req, pid: pid)
    }
}
