//
//  ReportManager.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation
import Pjango

class ReportManager {
    
    static let shared = ReportManager.init()
    
    var reportCache = [String: DailyReport]()
    
    func reportForDate(date: String) -> DailyReport? {
        if let report = reportCache[date] {
            return report
        }
        if let report = DailyReport.init(date: date) {
            if date != Date.today.dayStringValue {
                reportCache[date] = report
            }
            return report
        } else {
            return nil
        }
    }
    
}
