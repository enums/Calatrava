//
//  DailyReportView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation
import PerfectHTTP
import Pjango

class DailyReportView: PCListView {
    
    override var templateName: String? {
        return "report_daily.html"
    }
    
    var currentDate: Date?
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let dateStr = req.urlVariables["date"] else {
            return false
        }
        if dateStr == "today" {
            currentDate = Date.today
            return true
        } else {
            guard let dateParam = "\(dateStr) 00:00:00".dateValue, ReportManager.shared.reportForDate(date: dateStr) != nil else {
                return false
            }
            currentDate = dateParam
            return true
        }
    }
    
    override func requestInvaildHandle() -> PCUrlHandle? {
        return pjangoHttpRedirect(name: "error.404")
    }
    
    override var listObjectSets: [String : [PCModel]]? {
        guard var date = currentDate else {
            return nil
        }
        for _ in 0..<3 {
            let newDate = Date.init(timeInterval: 24 * 3600, since: date)
            if newDate.timeIntervalSince1970 > Date.today.timeIntervalSince1970 {
                break
            }
            date = newDate
        }
        var list = [ReportOnlyDateModel]()
        for _ in 0..<7 {
            let model = ReportOnlyDateModel.init(date: date.dayStringValue)
            list.append(model)
            if currentDate?.dayStringValue == date.dayStringValue {
                model.selected = true
            }
            date = Date.init(timeInterval: -24 * 3600, since: date)
        }
        return [
            "_pjango_param_table_close_date": list
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? ReportOnlyDateModel else {
            return nil
        }
        return [
            "_pjango_param_table_close_date_DATE": model.date,
            "_pjango_param_table_close_date_COLOR": model.selected ? "white" : "rgba(178, 178, 178, 1)"
        ]
    }
    
    override var viewParam: PCViewParam? {
        guard let date = currentDate, let report = ReportManager.shared.reportForDate(date: date.dayStringValue) else {
            return nil
        }
        
        let message = ConfigModel.getValueForKey(.reportDailyMessage) ?? "null"
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_message": message,
            
            "_pjango_url_posts": "posts.\(WEBSITE_HOST)",
            "_pjango_url_corpus": "corpus.\(WEBSITE_HOST)",
            "_pjango_url_report_daily": "\(WEBSITE_HOST)/report/daily",
            
            "_pjango_chart_daily_pv_data": report.pvData(),
            "_pjango_chart_daily_read_data": report.readData(),
            "_pjango_param_date": date.dayStringValue
        ]
    }
    
    
}
