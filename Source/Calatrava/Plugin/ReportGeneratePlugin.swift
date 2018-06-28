//
//  ReportGeneratePlugin.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/27.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class ReportGeneratePlugin: PCTimerPlugin {
    
    // 次日凌晨3点
    override var timerDelay: TimeInterval {
        return Date.tomorrow.timeIntervalSince1970 + 3 * 3600 - Date.init().timeIntervalSince1970
    }
    
    override var timerInterval: TimeInterval {
        return 24 * 3600
    }
    
    override var task: PCTask? {
        return {
            logger.info("[Report] Generating!")
            ReportDailyModel.generateAllReport()
            logger.info("[Report] Generated!")
        }
    }
}
