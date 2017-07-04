//
//  LoveCleanPlugin.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2017/6/25.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

class LoveCleanPlugin: PCTimerPlugin {
    
    override var timerDelay: TimeInterval {
        return Date.tomorrow.timeIntervalSince1970 - Date.init().timeIntervalSince1970
    }
    
    override var timerInterval: TimeInterval {
        return 3600 * 24
    }
    
    override var task: PCTask? {
        return {
            logger.info("[CustomerCleaner]: Clean love recoreds.")
            postsLoveDict.removeAll()
        }
    }
}

