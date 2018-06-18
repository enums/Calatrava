//
//  UpdateModel.swift
//  Calatrava
//
//  Created by 郑宇琦 on 2018/6/18.
//  Copyright © 2017年 郑宇琦. All rights reserved.
//

import Foundation
import Pjango

enum UpdateModelType {
    case posts
    case project
    case corpus
    case instagram
    case bilibili
}

class UpdateModel: PCModel {
    
    var type: UpdateModelType
    var model: PCModel
    var date: String
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    init(type: UpdateModelType, model: PCModel, date: String) {
        self.type = type
        self.model = model
        self.date = date
    }
    
    convenience init(_ postsModel: PostsModel) {
        self.init(type: .posts, model: postsModel, date: postsModel.date.strValue)
    }
    
    convenience init(_ projectModel: ProjectModel) {
        self.init(type: .project, model: projectModel, date: projectModel.date.strValue)
    }
    
    convenience init(_ corpusModel: CorpusPostsModel) {
        self.init(type: .corpus, model: corpusModel, date: corpusModel.date.strValue)
    }
    
    convenience init(_ insModel: InstagramFeedModel) {
        self.init(type: .instagram, model: insModel, date: insModel.date.strValue)
    }
    
    convenience init(_ biliModel: BilibiliFeedModel) {
        self.init(type: .bilibili, model: biliModel, date: biliModel.date.strValue)
    }
    
    func generateTemplate() -> String {
        switch type {
        case .posts: return UpdatePostsView.init(model: model as! PostsModel).getTemplate()
        case .project: return UpdateProjectView.init(model: model as! ProjectModel).getTemplate()
        case .corpus: return UpdateCorpusView.init(model: model as! CorpusPostsModel).getTemplate()
        case .instagram: return UpdateInstagramView.init(model: model as! InstagramFeedModel).getTemplate()
        case .bilibili: return UpdateBilibiliView.init(model: model as! BilibiliFeedModel).getTemplate()
        }
    }
    
}
