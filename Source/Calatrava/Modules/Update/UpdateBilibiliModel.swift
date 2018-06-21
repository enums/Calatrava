//
//  UpdateBilibiliView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/24.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class UpdateBilibiliView: PCDetailView {
    
    var model: BilibiliFeedModel
    
    init(model: BilibiliFeedModel) {
        self.model = model
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override var templateName: String? {
        return "update_bilibili_cell.html"
    }
    
    override var viewParam: PCViewParam? {
        var coverName = ""
        if model.cover.strValue != "null" {
            coverName = model.cover.strValue
        } else {
            coverName = "\(model.blid.intValue)_cover.jpg"
        }
        let coverUrl = "bilibili.\(WEBSITE_HOST)/img/bilibili/\(coverName)"
        let list = ((BilibiliListModel.queryObjects() as? [BilibiliListModel])?.filter { $0.blid.intValue == model.blid.intValue })?.first
        
        let name = ConfigModel.getValueForKey(.bilibiliName) ?? "null"
        let listTitle = list?.name.strValue ?? "null"
        
        return [
            "_pjango_param_name": name,
            "_pjango_param_title": model.name.strValue,
            "_pjango_param_list_title": listTitle,
            "_pjango_param_image": coverUrl,
            "_pjango_param_url": model.url.strValue,
            "_pjango_param_blid": model.blid.intValue,
            "_pjango_param_memo": model.memo.strValue,
            "_pjango_param_date": model.date.strValue,

            "_pjango_url_bilibili": "bilibili.\(WEBSITE_HOST)"
        ]
    }
    
}
