//
//  MessageHandle.swift
//  Calatrava-Blog
//
//  Created by 郑宇琦 on 2017/12/21.
//

import Foundation
import Pjango
import SwiftyJSON

func messageHandle() -> PCUrlHandle {
    
    return pjangoHttpResponse { req, res in
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
        guard let name = json["name"].string, let email = json["email"].string, let comment = json["comment"].string else {
            pjangoHttpResponse("请把内容填写完整哦！")(req, res)
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
        guard comment.count > 2 else {
            pjangoHttpResponse("评论太短啦！")(req, res)
            return
        }
        let ip = req.remoteAddress.host
        if let lastTime = messageLastTimeDict[ip] {
            guard Date.init().timeIntervalSince1970 - lastTime > 10 else {
                logger.info("Message - Frequency anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
                pjangoHttpResponse("你提交得太频繁啦！")(req, res)
                return
            }
        }
        messageLastTimeDict[ip] = Date.init().timeIntervalSince1970
        if let count = messageDailyDict[ip] {
            messageDailyDict[ip] = count + 1
        } else {
            messageDailyDict[ip] = 1
        }
        if let count = messageDailyDict[ip], count >= 40 {
            logger.info("Message - Quantity anomaly @ \(ip): NAME: \(name), EMAIL: \(email), COMMENT: \(comment)")
            pjangoHttpResponse("今天提交的次数已达上限啦！")(req, res)
            return
        }
        
        let date = Date.init().stringValue;
        let messageModel = MessageModel.init()
        messageModel.mid.strValue = "\(name)#\(date)@\(ip)"
        messageModel.date.strValue = date
        messageModel.name.strValue = name
        messageModel.email.strValue = email
        messageModel.comment.strValue = comment
        messageModel.fromIp.strValue = ip;
        guard MessageModel.insertObject(messageModel) else {
            pjangoHttpResponse("居然出错了！")(req, res)
            return
        }
        pjangoHttpResponse("发表成功！")(req, res)
        EventHooks.hookLeaveMessage(req: req)
    }
    
}
