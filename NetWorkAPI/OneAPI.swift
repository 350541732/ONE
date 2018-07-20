//
//  OneAPI.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
import Moya

/*
  [One-API:https://github.com/350541732/one-api]
 */

let oneAPIProvider = MoyaProvider<OneAPI>()

enum OneAPI {
    
    case home
    case banner
    case article
    case askAll
    case hotAuther
    
}

extension OneAPI:TargetType {
        
    var baseURL:URL {
        return URL(string: "http://v3.wufazhuce.com:8000/api")!
    }
    
    var path:String {
        switch self {
        case .home:
            return "/channel/one/0/青岛市".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case .banner:
            return "/banner/list/3"
        case .article:
            return  "/banner/list/4"
        case .askAll:
            return "/banner/list/5"
        case .hotAuther:
            return "/author/hot"
        }
    }
    
    var method:Moya.Method {
        return .get
    }
    
    var task:Task {
        // send no parameters
        return .requestPlain
    }
    
    var sampleData: Data {
        return "..".data(using: String.Encoding.utf8)!
    }
    
    var headers : [String:String]? {
        return ["Content-type": "application/json"]
    }
    
    var validata :Bool {
        return false
    }
}
