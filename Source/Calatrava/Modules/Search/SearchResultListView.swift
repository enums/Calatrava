//
//  SearchResultListView.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2019/2/23.
//

import Foundation
import PerfectLib
import Pjango

class SearchResultListView: PCListView {
    
    override var templateName: String? {
        return "search_result.html"
    }
    
    var searchResult: [PCModel]?
    
    override var listObjectSets: [String : [PCModel]]? {
        defer {
            searchResult = nil
        }
        return [
            "_pjango_param_table_result": searchResult ?? [],
        ]
    }
    
    override func listUserField(inList list: String, forModel model: PCModel) -> PCViewParam? {
        guard let model = model as? SearchModelProtocol else {
            return nil
        }
        return [
            "_pjango_param_table_result_HTML": model.toSearchHTML()
        ]
    }
    
    override var viewParam: PCViewParam? {
        
        let titleMessage = ConfigModel.getValueForKey(.titleMessage) ?? "null"
        
        guard let req = currentRequest else {
            return nil;
        }
        
        let allTags = (ModuleModel.queryObjects() as? [ModuleModel])?.filter { $0.searchable.intValue > 0 }.map { $0.toViewParam() } ?? []
        
        var page = 1
        if let pageParam = Int(req.getUrlParam(key: "page") ?? ""), pageParam > 0 {
            page = pageParam
        }
        let eachPageResultCount = 12
        let ignorePostman = Bool(req.getUrlParam(key: "ignore_postman") ?? "") ?? true
        let ignorePostmanButtonTitle = ignorePostman ? "显示 Postman 抓取 Instagram 的内容" : "隐藏 Postman 抓取 Instagram 的内容"
        
        let module = req.getUrlParam(key: "module") ?? ""
        let keyword = req.getUrlParam(key: "keyword") ?? ""
        let keywordList = keyword.split(separator: " ")
        let lowercasedKeywordList = keywordList.map { $0.lowercased() }
        
        var result: [PCModel]
        if module != "" {
            result = search(module: module, with: lowercasedKeywordList, ignorePostman: ignorePostman)
        } else {
            result = searchAllModuleWithKeyword(keywords: lowercasedKeywordList, ignorePostman: ignorePostman)
        }
        let totalCount = result.count;
        
        let begin = eachPageResultCount * (page - 1)
        let end = eachPageResultCount * page - 1
        if (begin < result.count) {
            let trueEnd = min(result.count - 1, end)
            searchResult = Array(result[begin..<(trueEnd + 1)])
        } else {
            searchResult = []
        }
        
        EventHooks.hookSearchAll(req: req, module: module, keyword: keyword)
        
        return [
            "_pjango_template_navigation_bar": NavigationBarView.html,
            "_pjango_template_footer_bar": FooterBarView.html,
            "_pjango_param_title_message": titleMessage,
            
            "_pjango_param_param_module": module,
            "_pjango_param_param_keyword": keyword,
            "_pjango_param_param_page": page,
            "_pjango_param_param_ignore_postman": ignorePostman,
            "_pjango_param_param_ignore_postman_button_title": ignorePostmanButtonTitle,
            
            "_pjango_param_param_page_total": max(0, result.count - 1) / eachPageResultCount + 1,
            "_pjango_param_param_total_count": totalCount,
            
            "_pjango_param_all_tags": allTags,
            
            "_pjango_param_host": WEBSITE_HOST,
        ];
    }
    
    func searchAllModuleWithKeyword(keywords: [String], ignorePostman: Bool) -> [PCModel] {
        var modules: [String]
        if (ignorePostman) {
            modules = ["技术博文", "文集文章", "业余项目", "原创视频"]
        } else {
            modules = ["技术博文", "文集文章", "业余项目", "原创视频", "图片抓取"]
        }
        var result = [PCModel]()
        for module in modules {
            result += search(module: module, with: keywords, ignorePostman: ignorePostman)
        }
        return result.sorted { ($0 as! SearchModelProtocol).toSearchDate() > ($1 as! SearchModelProtocol).toSearchDate() }
    }
    
    func search(module: String, with keywords: [String], ignorePostman: Bool) -> [PCModel] {
        if (module == "技术博文") {
            guard var postsList = PostsModel.queryObjects() as? [PostsModel] else {
                return [];
            }
            
            if !keywords.isEmpty {
                postsList = postsList.filter {
                    for keyword in keywords {
                        guard keyword != "" else {
                            continue
                        }
                        guard $0.title.strValue.lowercased().contains(string: keyword) ||
                            $0.date.strValue.lowercased().contains(string: keyword) ||
                            $0.tag.strValue.lowercased().contains(string: keyword) ||
                            $0.mdContainKeyword(keyword: keyword) else {
                            return false
                        }
                    }
                    return true
                }
            }
            
            return postsList.sorted { $0.date.strValue > $1.date.strValue }
        } else if (module == "文集文章") {
            guard var postsList = CorpusPostsModel.queryObjects() as? [CorpusPostsModel] else {
                return [];
            }
            if !keywords.isEmpty {
                postsList = postsList.filter { posts in
                    let corpus = ((CorpusModel.queryObjects() as? [CorpusModel])?.filter { $0.cid.intValue == posts.cid.intValue })?.first
                    let corpusTitle = corpus?.title.strValue ?? ""
                    for keyword in keywords {
                        guard keyword != "" else {
                            continue
                        }
                        guard posts.title.strValue.lowercased().contains(string: keyword) ||
                            posts.date.strValue.lowercased().contains(string: keyword) ||
                            corpusTitle.lowercased().contains(string: keyword) ||
                            posts.mdContainKeyword(keyword: keyword) else {
                            return false
                        }
                    }
                    return true
                }
            }
            
            return postsList.sorted { $0.date.strValue > $1.date.strValue }
        } else if (module == "业余项目") {
            guard var projectList = ProjectModel.queryObjects() as? [ProjectModel] else {
                return [];
            }
            if !keywords.isEmpty {
                projectList = projectList.filter {
                    for keyword in keywords {
                        guard keyword != "" else {
                            continue
                        }
                        guard $0.title.strValue.lowercased().contains(string: keyword) ||
                            $0.subtitle.strValue.lowercased().contains(string: keyword) ||
                            $0.tag.strValue.lowercased().contains(string: keyword) ||
                            $0.memo.strValue.lowercased().contains(string: keyword) ||
                            $0.date.strValue.lowercased().contains(string: keyword) else {
                            return false
                        }
                    }
                    return true
                }
            }
            
            return projectList.sorted { $0.date.strValue > $1.date.strValue }
        } else if (module == "原创视频") {
            guard var videoList = BilibiliFeedModel.queryObjects() as? [BilibiliFeedModel] else {
                return [];
            }
            if !keywords.isEmpty {
                videoList = videoList.filter { video in
                    for keyword in keywords {
                        guard keyword != "" else {
                            continue
                        }
                        let corpus = ((BilibiliListModel.queryObjects() as? [BilibiliListModel])?.filter { $0.blid.intValue == video.blid.intValue })?.first
                        let corpusTitle = corpus?.name.strValue ?? ""
                        let corpusMemo = corpus?.memo.strValue ?? ""
                        guard video.name.strValue.lowercased().contains(string: keyword) ||
                            video.memo.strValue.lowercased().contains(string: keyword) ||
                            video.date.strValue.lowercased().contains(string: keyword) ||
                            corpusTitle.lowercased().contains(string: keyword) ||
                            corpusMemo.lowercased().contains(string: keyword) else {
                            return false
                        }
                    }
                    return true
                }
            }
            
            return videoList.sorted { $0.date.strValue > $1.date.strValue }
        } else if (module == "图片抓取" && ignorePostman == false) {
            guard var imageList = InstagramFeedModel.queryObjects() as? [InstagramFeedModel] else {
                return [];
            }
            if !keywords.isEmpty {
                imageList = imageList.filter {
                    for keyword in keywords {
                        guard keyword != "" else {
                            continue
                        }
                        guard $0.name.strValue.lowercased().contains(string: keyword) ||
                            $0.full_name.strValue.lowercased().contains(string: keyword) ||
                            $0.bio.strValue.lowercased().contains(string: keyword) ||
                            $0.id.strValue.lowercased().contains(string: keyword) ||
                            $0.caption.strValue.lowercased().contains(string: keyword) ||
                            $0.date.strValue.lowercased().contains(string: keyword) else {
                            return false
                        }
                    }
                    return true
                }
            }
            
            return imageList.sorted { $0.date.strValue > $1.date.strValue }
        } else {
            return []
        }
    }
}

protocol SearchModelProtocol {
    func toSearchHTML() -> String
    func toSearchDate() -> String
}

extension PostsModel: SearchModelProtocol {
    func toSearchHTML() -> String {
        return SearchResultPostsView.init(model: self).getTemplate()
    }
    func toSearchDate() -> String {
        return self.date.strValue
    }
    func mdContainKeyword(keyword: String) -> Bool {
        let pid = self.pid.intValue
        let file = File.init("\(PJANGO_TEMPLATES_DIR)/_posts/\(pid).md")
        guard let content = try? file.readString() else {
            return false
        }
        let lowercasedContent = content.lowercased()
        return lowercasedContent.contains(string: keyword)
    }
}

extension CorpusPostsModel: SearchModelProtocol {
    func toSearchHTML() -> String {
        return SearchResultCorpusView.init(model: self).getTemplate()
    }
    func toSearchDate() -> String {
        return self.date.strValue
    }
    func mdContainKeyword(keyword: String) -> Bool {
        let cpid = self.cpid.intValue
        let file = File.init("\(PJANGO_TEMPLATES_DIR)/_corpus/\(cpid).md")
        guard let content = try? file.readString() else {
            return false
        }
        let lowercasedContent = content.lowercased()
        return lowercasedContent.contains(string: keyword)
    }
}

extension BilibiliFeedModel: SearchModelProtocol {
    func toSearchHTML() -> String {
        return SearchResultBilibiliView.init(model: self).getTemplate()
    }
    func toSearchDate() -> String {
        return self.date.strValue
    }
}

extension InstagramFeedModel: SearchModelProtocol {
    func toSearchHTML() -> String {
        return SearchResultInstagramView.init(model: self).getTemplate()
    }
    func toSearchDate() -> String {
        return self.date.strValue
    }
}

extension ProjectModel: SearchModelProtocol {
    func toSearchHTML() -> String {
        return SearchResultProjectView.init(model: self).getTemplate()
    }
    func toSearchDate() -> String {
        return self.date.strValue
    }
}


