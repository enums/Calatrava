//
//  CorpusPostsCommentHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/12/30.
//

import Foundation
import Pjango
import SwiftyJSON

func corpusPostsCommentHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
        guard let postsList = CorpusPostsModel.queryObjects() else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        guard let jsonStr = req.postBodyString else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
            return
        }
        let json = JSON.parse(jsonStr)
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
        guard let cpid = json["cpid"].int, let name = json["name"].string, let email = json["email"].string, let comment = json["comment"].string else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
            return
        }
        let tmpPosts = postsList.filter {
            let posts = $0 as! CorpusPostsModel
            return posts.cpid.intValue == cpid
            }.first as? CorpusPostsModel
        guard tmpPosts != nil else {
            pjangoHttpResponse("目标博文不存在！")(req, res)
            return
        }
        guard name.characters.count > 2 else {
            pjangoHttpResponse("昵称太短啦！")(req, res)
            return
        }
        guard email.contains(string: "@"), email.contains(string: "."), email.characters.count > 5 else {
            pjangoHttpResponse("邮箱地址不合法！")(req, res)
            return
        }
        guard comment.characters.count > 2 else {
            pjangoHttpResponse("评论太短啦！")(req, res)
            return
        }
        let ip = req.remoteAddress.host
        if let lastTime = corpusPostsCommentLastTimeDict[ip] {
            guard Date.init().timeIntervalSince1970 - lastTime > 1 else {
                logger.info("Comment - Frequency anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
                pjangoHttpResponse("你提交得太频繁啦！")(req, res)
                return
            }
        }
        corpusPostsCommentLastTimeDict[ip] = Date.init().timeIntervalSince1970
        if let count = corpusPostsCommentDailyDict[ip] {
            corpusPostsCommentDailyDict[ip] = count + 1
        } else {
            corpusPostsCommentDailyDict[ip] = 1
        }
        if let count = corpusPostsCommentDailyDict[ip], count >= 960 {
            logger.info("Comment - Quantity anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
            pjangoHttpResponse("今天提交的次数已达上限啦！")(req, res)
            return
        }
        
        let date = Date.init().stringValue;
        let commentModel = CorpusPostsCommentModel.init()
        commentModel.cpcid.strValue = "\(cpid)_\(name)#\(date)@\(ip)"
        commentModel.cpid.intValue = cpid
        commentModel.date.strValue = date
        commentModel.name.strValue = name
        commentModel.email.strValue = email
        commentModel.comment.strValue = comment
        commentModel.fromIp.strValue = ip
        guard CorpusPostsCommentModel.insertObject(commentModel) else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        pjangoHttpResponse("发表成功！")(req, res)
        EventHooks.hookCorpusPostsComment(req: req, cpid: cpid)
    }
    
}
