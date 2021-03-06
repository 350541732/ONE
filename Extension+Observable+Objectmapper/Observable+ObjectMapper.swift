//
//  Observable+ObjectMapper.swift
//  CrewLogger
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            //解析数据-> 'result'
            guard let dic = response as? [String:Any] else{
                throw RxSwiftMoyaError.ParseJSONError
            }
            guard let array = dic["result"] as? [Any] else{
                throw RxSwiftMoyaError.ParseJSONError
            }
//            guard let array = response as? [Any] else {
//                throw RxSwiftMoyaError.ParseJSONError
//            }
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }            
            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
}

enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error { }

