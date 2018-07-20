//
//  ListDetailModel.swift
//  rxSwiftNodeElm
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources


class ListDetailModel : NSObject, Mappable{
    
    var contentList : [ContentList]?
    var date : String?
    var id : String?
    var menu : Menu?
    var weather : Weather?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ListDetailModel()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        contentList <- map["content_list"]
        date <- map["date"]
        id <- map["id"]
        menu <- map["menu"]
        weather <- map["weather"]
        
    }
}

class Weather : NSObject, Mappable{
    
    var cityName : String?
    var climate : String?
    var date : String?
    var humidity : String?
    var hurricane : String?
    var icons : Icon?
    var temperature : String?
    var windDirection : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Weather()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        cityName <- map["city_name"]
        climate <- map["climate"]
        date <- map["date"]
        humidity <- map["humidity"]
        hurricane <- map["hurricane"]
        icons <- map["icons"]
        temperature <- map["temperature"]
        windDirection <- map["wind_direction"]
        
    }
}

class Icon : NSObject, Mappable{
    
    var day : String?
    var night : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Icon()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        day <- map["day"]
        night <- map["night"]
        
    }
}

class Menu : NSObject, Mappable{
    
    var list : [List]?
    var vol : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Menu()
    }
    required init?(map: Map){}
    override init(){}
    
    func mapping(map: Map)
    {
        list <- map["list"]
        vol <- map["vol"]
        
    }
}
class List : NSObject, Mappable{
    
    var contentId : String?
    var contentType : String?
    var serialList : [String]?
    var tag : Tag?
    var title : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return List()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        contentId <- map["content_id"]
        contentType <- map["content_type"]
        serialList <- map["serial_list"]
        tag <- map["tag"]
        title <- map["title"]
        
    }
}
class Tag : NSObject, Mappable{
    
    var id : String?
    var title : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return Tag()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
        
    }
}
class ContentList : NSObject, Mappable{
    
    var adClosetime : String?
    var adId : Int?
    var adLinkurl : String?
    var adMakettime : String?
    var adPvurl : String?
    var adPvurlVendor : String?
    var adShareCnt : String?
    var adType : Int?
    var audioPlatform : Int?
    var audioUrl : String?
    var author : Author?
    var category : String?
    var contentBgcolor : String?
    var contentId : String?
    var contentType : String?
    var displayCategory : String?
    var forward : String?
    var hasReading : Int?
    var id : String?
    var imgUrl : String?
    var itemId : String?
    var lastUpdateDate : String?
    var likeCount : Int?
    var movieStoryId : String?
    var number : Int?
    var picInfo : String?
    var postDate : String?
    var serialId : Int?
    var serialList : [AnyObject]?
    var shareUrl : String?
    var startVideo : String?
    var subtitle : String?
    var tagList : [AnyObject]?
    var title : String?
    var videoUrl : String?
    var volume : Int?
    var wordsInfo : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ContentList()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        adClosetime <- map["ad_closetime"]
        adId <- map["ad_id"]
        adLinkurl <- map["ad_linkurl"]
        adMakettime <- map["ad_makettime"]
        adPvurl <- map["ad_pvurl"]
        adPvurlVendor <- map["ad_pvurl_vendor"]
        adShareCnt <- map["ad_share_cnt"]
        adType <- map["ad_type"]
        audioPlatform <- map["audio_platform"]
        audioUrl <- map["audio_url"]
        author <- map["author"]
        category <- map["category"]
        contentBgcolor <- map["content_bgcolor"]
        contentId <- map["content_id"]
        contentType <- map["content_type"]
        displayCategory <- map["display_category"]
        forward <- map["forward"]
        hasReading <- map["has_reading"]
        id <- map["id"]
        imgUrl <- map["img_url"]
        itemId <- map["item_id"]
        lastUpdateDate <- map["last_update_date"]
        likeCount <- map["like_count"]
        movieStoryId <- map["movie_story_id"]
        number <- map["number"]
        picInfo <- map["pic_info"]
        postDate <- map["post_date"]
        serialId <- map["serial_id"]
        serialList <- map["serial_list"]
        shareUrl <- map["share_url"]
        startVideo <- map["start_video"]
        subtitle <- map["subtitle"]
        tagList <- map["tag_list"]
        title <- map["title"]
        videoUrl <- map["video_url"]
        volume <- map["volume"]
        wordsInfo <- map["words_info"]
        
    }
}

class Author : NSObject, Mappable{
    
    var desc : String?
    var fansTotal : String?
    var isSettled : String?
    var settledType : String?
    var summary : String?
    var userId : String?
    var userName : String?
    var wbName : String?
    var webUrl : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Author()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        desc <- map["desc"]
        fansTotal <- map["fans_total"]
        isSettled <- map["is_settled"]
        settledType <- map["settled_type"]
        summary <- map["summary"]
        userId <- map["user_id"]
        userName <- map["user_name"]
        wbName <- map["wb_name"]
        webUrl <- map["web_url"]
        
    }
}

/*
 rxDataSource
 */
struct FirstCellModelData {
    
    var headers:String
    var items:[Item]
}

extension FirstCellModelData :SectionModelType {
    
    typealias Item = ContentList
    
    init(original: FirstCellModelData, items: [Item]) {
        self = original
        self.items = items
    }    
}
