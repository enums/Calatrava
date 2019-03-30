//
//  PostsOldHandle.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/26.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

func postsOldHandle() -> PCUrlHandle {
    return { req, res in
        let pid = Int(req.getUrlParam(key: "pid") ?? "-1") ?? -1
        pjangoHttpRedirect(url: "http://\(WEBSITE_HOST)/posts/article/\(pid)")(req, res)
    }
}
