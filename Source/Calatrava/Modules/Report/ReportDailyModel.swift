//
//  ReportDailyModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/5/20.
//

import Foundation
import Pjango
import SwiftyJSON

class ReportDailyModel: PCModel {

    override var tableName: String {
        return "ReportDaily"
    }

    var date = PCDataBaseField.init(name: "DATE", type: .string, length: 16)
    var events = PCDataBaseField.init(name: "EVENTS", type: .text, length: 65536)

    var eventsDict: [VisitStatisticsEventType: [String]]? {
        get {
            let jsonStr = events.strValue
            let json = JSON.init(parseJSON: jsonStr)
            guard let dictJson = json.dictionary else {
                return nil
            }
            var result = [VisitStatisticsEventType: [String]]()
            dictJson.forEach { (key, value) in
                guard let type = VisitStatisticsEventType(rawValue: key), let list = value.array else {
                    return
                }
                let params = list.compactMap { $0.string }
                result[type] = params
            }
            return result
        }
        set {
            guard let newDict = newValue else {
                return
            }
            var result = [String: [String]]()
            newDict.forEach {
                result[$0.key.rawValue] = $0.value
            }
            self.events.strValue = JSON(result).description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        }
    }

    override func registerFields() -> [PCDataBaseField] {
        return [
            date, events
        ]
    }

    override class var cacheTime: TimeInterval? {
        return 60
    }


    static func reportForDate(date: String) -> ReportDailyModel? {
        let today = Date.today.dayStringValue
        guard date <= today else {
            return nil
        }
        if let report = (ReportDailyModel.queryObjects(ext: (false, "WHERE date like '\(date)%'")) as? [ReportDailyModel])?.first {
            return report
        } else {
            guard let models = VisitStatisticsModel.queryObjects(ext: (false, "WHERE date like '\(date)%'")) as? [VisitStatisticsModel], models.count > 0 else {
                return nil
            }
            let report = ReportDailyModel.init()
            report.date.strValue = date
            report.eventsDict = eventSpilt(models: models)
            if date < today {
                if !ReportDailyModel.insertObject(report) {
                    logger.error("Failed when insert ReportDaily! [\(date)]")
                }
            }
            return report
        }
    }

    fileprivate static func eventSpilt(models: [VisitStatisticsModel]) -> [VisitStatisticsEventType: [String]] {
        var eventSpiltDict = [VisitStatisticsEventType: [String]]()
        for model in models {
            guard let type = VisitStatisticsEventType(rawValue: model.event.strValue) else {
                continue
            }
            if eventSpiltDict[type] == nil {
                eventSpiltDict[type] = [model.param.strValue];
            } else {
                eventSpiltDict[type]!.append(model.param.strValue)
            }
        }
        return eventSpiltDict
    }

    static func allReport() -> [ReportDailyModel] {
        guard let reports = ReportDailyModel.queryObjects() as? [ReportDailyModel] else {
            return []
        }
        return reports
    }

    static func generateAllReport() {
        let today = Date.today.dayStringValue
        for year in 2018...2018 {
            for month in 1...12 {
                for day in 1...31 {
                    let date = "\(year)-\(String.init(format: "%02d", arguments: [month]))-\(String.init(format: "%02d", arguments: [day]))"
                    guard date < today else {
                        continue
                    }
                    _ = reportForDate(date: date)
                }
            }
        }
    }


    func dailyPv() -> [VisitStatisticsEventType : Int] {
        var result = [VisitStatisticsEventType : Int]()
        eventsDict?.forEach {
            result[$0] = $1.count
        }
        return result
    }

    func dailyRead() -> [VisitStatisticsEventType : [String : Int]] {
        var result = [VisitStatisticsEventType : [String : Int]]()
        eventsDict?.forEach { (type, params) in
            guard type == VisitStatisticsEventType.readPosts || type == VisitStatisticsEventType.readCorpusPosts else {
                return
            }
            var counter = [String: Int]()
            params.forEach { param in
                let id = param
                if counter[id] == nil {
                    counter[id] = 1
                } else {
                    counter[id]! += 1
                }
            }
            result[type] = counter
        }
        return result
    }

    func totalPv() -> [VisitStatisticsEventType: Int] {
        guard let keys = eventsDict?.keys else {
            return [:]
        }
        var result = [VisitStatisticsEventType: Int]()
        let types = Array(keys)
        types.forEach { (type) in
            result[type] = eventsDict?[type]?.count ?? 0
        }
        return result
    }
}
