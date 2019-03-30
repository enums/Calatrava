//
//  ReportDailyView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation
import PerfectHTTP
import Pjango

class ReportDailyView: PCListView {
    
    override var templateName: String? {
        return "report_daily.html"
    }
    
    var currentDate: Date?
    var currentReport: ReportDailyModel?
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let dateStr = req.urlVariables["date"] else {
            return false
        }
        if dateStr == "today", let report = ReportDailyModel.reportForDate(date: Date.today.dayStringValue) {
            currentDate = Date.today
            currentReport = report
            return true
        } else {
            guard let dateParam = "\(dateStr) 00:00:00".dateValue,
                  let report = ReportDailyModel.reportForDate(date: dateStr) else {
                return false
            }
            currentDate = dateParam
            currentReport = report
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
        guard let date = currentDate,
              let report = currentReport else {
            return nil
        }
        
        let message = ConfigModel.getValueForKey(.reportDailyMessage) ?? "null"
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        EventHooks.hookReportDaily(req: currentRequest, date: date.dayStringValue)
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_message": message,
            
            "_pjango_url_host": WEBSITE_HOST,
            
            "_pjango_chart_daily_pv_data": report.dailyPvData(),
            "_pjango_chart_daily_read_data": report.dailyReadData(),
            "_pjango_param_date": date.dayStringValue
        ]
    }
}

extension ReportDailyModel {
    
    func dailyPvData() -> String {
        let pv = dailyPv()
        let legendDataList = Array(pv.keys).map { "'\($0.displayValue)'" }.sorted(by: >)
        let seriesDataList = Array(pv.keys).map { "{name: '\($0.displayValue)', value: \(pv[$0] ?? 0)}" }
        let legendData = "[\(legendDataList.joined(separator: ", "))]"
        let seriesData = "[\(seriesDataList.joined(separator: ", "))]"
        return "legendData: \(legendData), seriesData: \(seriesData)"
    }
    
    func dailyReadData() -> String {
        let read = dailyRead()
        var legendDataList = [String]()
        var insideSeriesDataList = [String]()
        var outsideSeriesDataList = [String]()
        read.forEach { (type, read) in
            guard type == VisitStatisticsEventType.readPosts || type == VisitStatisticsEventType.readCorpusPosts else {
                return
            }
            legendDataList.append("'\(type.displayValue)'")
            insideSeriesDataList.append("{name: '\(type.displayValue)', value: \(read.reduce(0) { $0 + $1.value })}")
            read.forEach { (id, count) in
                legendDataList.append("'\(type.displayValue)_\(id)'")
                outsideSeriesDataList.append("{name: '\(type.displayValue)_\(id)', value: \(count)}")
            }
        }
        legendDataList = legendDataList.sorted(by: >)
        let legendData = "[\(legendDataList.joined(separator: ", "))]"
        let insideSeriesData = "[\(insideSeriesDataList.joined(separator: ", "))]"
        let outsideSeriesData = "[\(outsideSeriesDataList.joined(separator: ", "))]"
        return "legendData: \(legendData), insideSeriesData: \(insideSeriesData), outsideSeriesData: \(outsideSeriesData)"
    }
}
