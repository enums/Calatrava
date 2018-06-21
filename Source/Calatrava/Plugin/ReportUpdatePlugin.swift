//
//  ReportUpdatePlugin.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ReportUpdatePlugin: PCTimerPlugin {
    
    override var timerInterval: TimeInterval {
        return 60 * 10
    }
    
    override var task: PCTask? {
        return {
            logger.info("[Report] Updating!")
            ReportCache.shared.updateCacheData()
            logger.info("[Report] Done!")
        }
    }
}
