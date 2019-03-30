//
//  ReportTotalView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/19.
//

import Foundation
import PerfectHTTP
import Pjango

enum ReportTotalViewOption: String {
    case all = "all"
    case week = "week"
    case monthOne = "month_1"
    case monthThree = "month_3"
}

class ReportTotalView: PCView {
    
    override var templateName: String? {
        return "report_total.html"
    }
    
    var currentOpt: ReportTotalViewOption?
    
    override func requestVaild(_ req: HTTPRequest) -> Bool {
        guard let optStr = currentRequest?.urlVariables["opt"],
              let opt = ReportTotalViewOption.init(rawValue: optStr) else {
            return false
        }
        currentOpt = opt
        return true
    }
    
    override func requestInvaildHandle() -> PCUrlHandle? {
        return pjangoHttpRedirect(name: "error.404")
    }
    
    override var viewParam: PCViewParam? {
        guard let opt = currentOpt else {
            return nil
        }
        
        var colorAll = "white"
        var colorWeek = "white"
        var colorMonthOne = "white"
        var colorMonthThree = "white"
        
        var beginDate = "2018-01-01"
        
        switch opt {
        case .all:
            colorAll = "rgba(178, 178, 178, 1)"
        case .week:
            colorWeek = "rgba(178, 178, 178, 1)"
            beginDate = Date.init(timeInterval: -7 * 86400, since: Date.today).dayStringValue
        case .monthOne:
            colorMonthOne = "rgba(178, 178, 178, 1)"
            beginDate = Date.init(timeInterval: -30 * 86400, since: Date.today).dayStringValue
        case .monthThree:
            colorMonthThree = "rgba(178, 178, 178, 1)"
            beginDate = Date.init(timeInterval: -3 * 30 * 86400, since: Date.today).dayStringValue
        }
        
        let postsList = PostsModel.queryObjects() as? [PostsModel] ?? []
        let corpusPostsList = CorpusPostsModel.queryObjects() as? [CorpusPostsModel] ?? []
        
        let readSum = postsList.reduce(0) {
            $0 + $1.read.intValue
            } + corpusPostsList.reduce(0) {
                $0 + $1.read.intValue
        }
        let loveSum = postsList.reduce(0) {
            $0 + $1.love.intValue
            } + corpusPostsList.reduce(0) {
                $0 + $1.love.intValue
        }
        let counterIndex = Int(ConfigModel.getValueForKey(.counterIndex) ?? "0") ?? 0
        let counterList = Int(ConfigModel.getValueForKey(.counterPostsList) ?? "0") ?? 0
        let counterSearch = Int(ConfigModel.getValueForKey(.counterPostsSearch) ?? "0") ?? 0
        
        let message = ConfigModel.getValueForKey(.reportTotalMessage) ?? "null"
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        let dailyPvData = ReportCache.shared.cache?["_pjango_chart_daily_pv_data"] ?? ""
        let dailyIndexPvData = ReportCache.shared.cache?["_pjango_chart_daily_index_pv_data"] ?? ""
        let dailyReadData = ReportCache.shared.cache?["_pjango_chart_daily_read_data"] ?? ""
        let totalPvData = ReportCache.shared.cache?["_pjango_chart_total_pv_data"] ?? ""
        let totalReadData = ReportCache.shared.cache?["_pjango_chart_total_read_data"] ?? ""
        
        EventHooks.hookReportTotal(req: currentRequest, date: beginDate)
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            "_pjango_param_message": message,
            
            "_pjango_url_host": WEBSITE_HOST,
            
            "_pjango_param_color_all": colorAll,
            "_pjango_param_color_week": colorWeek,
            "_pjango_param_color_month_1": colorMonthOne,
            "_pjango_param_color_month_3": colorMonthThree,
            "_pjango_param_char_begin_date": beginDate,

            "_pjango_param_counter_posts": postsList.count + corpusPostsList.count,
            "_pjango_param_counter_read": readSum,
            "_pjango_param_counter_love": loveSum,
            "_pjango_param_counter_index": counterIndex,
            "_pjango_param_counter_list": counterList,
            "_pjango_param_counter_search": counterSearch,

            "_pjango_chart_daily_pv_data": dailyPvData,
            "_pjango_chart_daily_index_pv_data": dailyIndexPvData,
            "_pjango_chart_daily_read_data": dailyReadData,
            "_pjango_chart_total_pv_data": totalPvData,
            "_pjango_chart_total_read_data": totalReadData,
        ]
    }
}
