//
//  DailyReport.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation

class DailyReport {
    
    var date: String
    var eventSpiltDict = [VisitStatisticsEventType: [VisitStatisticsModel]]()
    
    init?(date: String) {
        self.date = date
        if !collectData() {
            return nil
        }
    }
    
    func collectData() -> Bool {
        guard let statistics = VisitStatisticsModel.queryObjects(ext: (true, "WHERE date like '\(date)%'")) as? [VisitStatisticsModel], statistics.count > 0 else {
            return false
        }
        
        var eventSpiltDict = [VisitStatisticsEventType: [VisitStatisticsModel]]()
        for statistic in statistics {
            guard let type = VisitStatisticsEventType.init(rawValue: statistic.event.strValue) else {
                continue
            }
            if eventSpiltDict[type] == nil {
                eventSpiltDict[type] = [statistic];
            } else {
                eventSpiltDict[type]!.append(statistic)
            }
        }
        self.eventSpiltDict = eventSpiltDict
        
        return true
    }
    
    func pvData() -> String {
        var legendDataList = [String]()
        var seriesDataList = [String]()
        eventSpiltDict.forEach { (type, models) in
            legendDataList.append("'\(type.displayValue)'")
            seriesDataList.append("{name: '\(type.displayValue)', value: \(models.count)}")
        }
        legendDataList = legendDataList.sorted(by: >)
        let legendData = "[\(legendDataList.joined(separator: ", "))]"
        let seriesData = "[\(seriesDataList.joined(separator: ", "))]"
        return "legendData: \(legendData),\nseriesData: \(seriesData)"
    }
    
    func readData() -> String {
        var legendDataList = [String]()
        var insideSeriesDataList = [String]()
        var outsideSeriesDataList = [String]()
        eventSpiltDict.forEach { (type, models) in
            guard type == VisitStatisticsEventType.readPosts || type == VisitStatisticsEventType.readCorpusPosts else {
                return
            }
            legendDataList.append("'\(type.displayValue)'")
            insideSeriesDataList.append("{name: '\(type.displayValue)', value: \(models.count)}")
            var counter = [String: Int]()
            models.forEach { model in
                let id = model.param.strValue
                if counter[id] == nil {
                    counter[id] = 1
                } else {
                    counter[id]! += 1
                }
            }
            counter.forEach { (id, count) in
                legendDataList.append("'\(type.displayValue)_\(id)'")
                outsideSeriesDataList.append("{name: '\(type.displayValue)_\(id)', value: \(count)}")
            }
        }
        legendDataList = legendDataList.sorted(by: >)
        let legendData = "[\(legendDataList.joined(separator: ", "))]"
        let insideSeriesData = "[\(insideSeriesDataList.joined(separator: ", "))]"
        let outsideSeriesData = "[\(outsideSeriesDataList.joined(separator: ", "))]"
        return "legendData: \(legendData),\ninsideSeriesData: \(insideSeriesData),\noutsideSeriesData: \(outsideSeriesData)"
    }
}

extension VisitStatisticsEventType {
    
    var displayValue: String {
        switch self {
        case .visitIndex: return "访问主页"
        case .visitProject: return "业余项目"
        case .visitAbout: return "查看关于"
        case .listPosts: return "查看博文列表"
        case .searchPosts: return "搜索博文"
        case .readPosts: return "阅读博文"
        case .lovePosts: return "点赞博文"
        case .commentPosts: return "评论博文"
        case .archivePosts: return "查看博文归档"
        case .listCorpus: return "查看文集列表"
        case .listCorpusPosts: return "查看文集文章列表"
        case .readCorpusPosts: return "阅读文集文章"
        case .loveCorpusPosts: return "点赞文集文章"
        case .commentCorpusPosts: return "评论文集文章"
        case .leaveMessage: return "留言"
        case .blogUpdate: return "查看动态聚合"
        case .visitInstagram: return "访问IG抓取"
        case .visitBilibili: return "访问原创视频"
        }
    }
    
}
