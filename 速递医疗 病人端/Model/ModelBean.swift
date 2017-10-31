//
//  ModelBean.swift
//
//

import UIKit
import ObjectMapper

class BaseModelBean: Mappable {
    var msg: String?
    var newslist: [newslistRowBean]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        newslist <- map["newslist"]
    }
}

class newslistRowBean: Mappable {
    var title: String?
    var description: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
    }
    
}
