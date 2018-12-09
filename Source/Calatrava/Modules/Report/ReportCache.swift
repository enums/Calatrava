//
//  ReportCache.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/20.
//

import Foundation

class ReportCache {
    
    static var shared = ReportCache.init()
    
    var cache: [String: String]?
    
    func updateCacheData() {
        var reports = ReportDailyModel.allReport()
        if let todayReport = ReportDailyModel.reportForDate(date: Date.today.dayStringValue) {
            reports.append(todayReport)
        }
        reports.sort(by: { $0.date.strValue < $1.date.strValue })
        
        let cache = [
            "_pjango_chart_daily_index_pv_data": totalDailyIndexPvData(allReport: reports),
            "_pjango_chart_total_pv_data": totalPvData(allReport: reports),
            "_pjango_chart_daily_pv_data": totalDailyPvData(allReport: reports),
            "_pjango_chart_total_read_data": totalReadData(allReport: reports),
            "_pjango_chart_daily_read_data": totalDailyReadData(allReport: reports),
            ]
        self.cache = cache
    }
    
    func totalDailyIndexPvData(allReport: [ReportDailyModel]) -> String {
        return "[\(allReport.map { "['\($0.date.strValue)', \($0.totalPv()[VisitStatisticsEventType.visitIndex] ?? 0)]" }.joined(separator: ", "))]"
    }
    
    func totalPvData(allReport: [ReportDailyModel]) -> String {
        var allPvs = [VisitStatisticsEventType: Int]()
        allReport.forEach { report in
            let pvs = report.dailyPv()
            pvs.forEach { (type, count) in
                if allPvs[type] == nil {
                    allPvs[type] = count
                } else {
                    allPvs[type]! += count
                }
            }
        }
        let legendDataList = Array(allPvs.keys).map { "'\($0.displayValue)'" }.sorted(by: >)
        let seriesDataList = Array(allPvs.keys).map { "{name: '\($0.displayValue)', value: \(allPvs[$0] ?? 0)}" }
        let legendData = "[\(legendDataList.joined(separator: ", "))]"
        let seriesData = "[\(seriesDataList.joined(separator: ", "))]"
        return "legendData: \(legendData), seriesData: \(seriesData)"
    }
    
    func totalDailyPvData(allReport: [ReportDailyModel]) -> String {
        return "[\(allReport.map { "['\($0.date.strValue)', \($0.totalPv().reduce(0) { $0 + $1.value })]" }.joined(separator: ", "))]"
    }
    
    func totalReadData(allReport: [ReportDailyModel]) -> String {
        var allRead = [VisitStatisticsEventType: [String : Int]]()
        var legendDataList = [String]()
        var insideSeriesDataList = [String]()
        var outsideSeriesDataList = [String]()
        allReport.forEach {
            $0.dailyRead().forEach { (type, read) in
                guard type == VisitStatisticsEventType.readPosts || type == VisitStatisticsEventType.readCorpusPosts else {
                    return
                }
                if allRead[type] == nil {
                    allRead[type] = read
                } else {
                    read.forEach {
                        if allRead[type]![$0.key] == nil {
                            allRead[type]![$0.key] = $0.value
                        } else {
                            allRead[type]![$0.key]! += $0.value
                        }
                    }
                }
            }
        }
        allRead.forEach { (type, read) in
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
    
    func totalDailyReadData(allReport: [ReportDailyModel]) -> String {
        var allRead = [String: [VisitStatisticsEventType: Int]]()
        allReport.forEach { report in
            report.dailyRead().forEach { (type, read) in
                guard type == VisitStatisticsEventType.readPosts || type == VisitStatisticsEventType.readCorpusPosts else {
                    return
                }
                if allRead[report.date.strValue] == nil {
                    allRead[report.date.strValue] = [VisitStatisticsEventType: Int]()
                }
                if allRead[report.date.strValue]![type] == nil {
                    allRead[report.date.strValue]![type] = read.reduce(0) { $0 + $1.value }
                } else {
                    allRead[report.date.strValue]![type]! += read.reduce(0) { $0 + $1.value }
                }
            }
        }
        let keys = Array(allRead.keys).sorted(by: <)
        
        return "[\(keys.map{ "['\($0)', \(allRead[$0]?[VisitStatisticsEventType.readPosts] ?? 0), \(allRead[$0]?[VisitStatisticsEventType.readCorpusPosts] ?? 0)]" }.joined(separator: ", "))]"
    }
}
