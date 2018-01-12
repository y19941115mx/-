//
//  BaseAPIBean.swift
//  速递医疗 病人端
//
//  Created by admin on 2017/10/31.
//  Copyright © 2017年 victor. All rights reserved.
//

import ObjectMapper

class BaseAPIBean:Mappable {
    var msg: String?
    var code: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
    }
}

class BaseBean<T:Mappable>:BaseAPIBean {
    var data: T?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class BaseListBean<T:Mappable>:BaseAPIBean {
    var dataList:[T]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataList <- map["data"]
    }
}

class DoctorListBean:BaseAPIBean {
    var doctorDataList:[DoctorBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        doctorDataList <- map["data"]
    }
}
/// 医生实体类
class DoctorBean:Mappable {
    var dept:String?
    var hospital:String?
    var allday: Bool = false
    var docId: Int = 0
    var distance:Int = 0
    var primary:String?
    var pix:String?
    var name:String?
    var hospitalLevel:String?
    var docLevel:String?
    var docexpert:String?
    var preordertypename:String?
    var account:String?
    var docabs:String? // 简介
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        docabs <- map["docabs"]
        dept <- map["docseconddept"]
        hospital <- map["dochosp"]
        allday <- map["docallday"]
        docId <- map["docloginid"]
        distance <- map["distance"]
        primary <- map["docprimarydept"]
        pix <- map["docloginpix"]
        name <- map["docname"]
        hospitalLevel <- map["hosplevel"]
        docLevel <- map["doctitle"]
        docexpert <- map["docexpert"]
        preordertypename <- map["preordertypename"]
        account <- map["dochuanxinaccount"]
    }
}

class OrderListBean:BaseAPIBean {
    var OrderDataList:[OrderBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        OrderDataList <- map["data"]
    }
}

class OrderBean: Mappable {
    var inhospname:String?
    var userorderstateid:Int?
    var docloginpix:String?
    var userorderprice:Double? // 订单价格
    var docaddresslocation:String? // 地点（医院名）
    var userorderappointment: String? // 预约时间
    var usersickdesc:String? // 病情描述
    var usersickpic:String?
    var familyname: String? // 就诊人姓名
    var familyage:Int?
    var userorderid: Int = 0 //订单Id
    var userorderstatename: String? // 订单状态描述
    var userorderetime: String? // 订单时间
    
    var userorderdprice:Double? // 出诊价格
    var userordertprice:Double? //交通价格
    var userorderaprice:Double? // 住宿价格
    var userordereprice:Double? // 餐饮价格
    var userordertpricetypename:String?
    var userorderapricetypename:String?
    var userorderepricetypename:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        inhospname <- map["inhospname"]
        userorderstateid <- map["userorderstateid"]
        userorderetime <- map["userorderetime"]
        docloginpix <- map["docloginpix"]
        usersickpic <- map["usersickpic"]
        familyage <- map["familyage"]
        userorderdprice <- map["userorderdprice"]
        userordertprice <- map["userordertprice"]
        userorderaprice <- map["userorderaprice"]
        userordereprice <- map["userordereprice"]
        userordertpricetypename <- map["userordertpricetypename"]
        userorderapricetypename <- map["userorderapricetypename"]
        userorderepricetypename <- map["userorderepricetypename"]
        
        userorderappointment <- map["userorderappointment"]
        userorderprice <- map["userorderprice"]
        docaddresslocation <- map["docaddresslocation"]
        familyname <- map["familyname"]
        userorderid <- map["userorderid"]
        usersickdesc <- map["usersickdesc"]
        userorderstatename <- map["userorderstatename"]
    }
}



class familyListBean:BaseAPIBean {
    var familyDataList: [familyBean]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        familyDataList <- map["data"]
    }
    
}

class familyBean:Mappable {
    var familyid: Int = 0
    var familyname: String?
    var familymale: String?
    var familyage: Int = 0
    var userloginid:Int = 0
    var familytype:Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        familyid <- map["familyid"]
        familyname <- map["familyname"]
        familymale <- map["familymale"]
        familyage <- map["familyage"]
        userloginid <- map["userloginid"]
        familytype <- map["familytype"]
    }
    
}

class sickListBean:BaseAPIBean {
    
    var sickDataList: [SickBean]?
    required init?(map: Map) {
        super.init(map: map)
    }
    override func mapping(map: Map) {
        super.mapping(map: map)
        sickDataList <- map["data"]
    }
    
}

//"familyid": 43,
//"usersickstateid": 4,
//"usersickseconddept": "呼吸内科",
//"familymale": "男",
//"userorderid": 22,
//"familyname": "王二",
//"usersickpic": "http://oytv6cmyw.bkt.clouddn.com/20171103055123751753.jpeg",
//"usersicktime": "Oct 16, 2017 5:12:03 PM",
//"usersickid": 81,
//"usersickprimarydept": "内科",
//"usersickdesc": "ghnhtffgtrghtdfb",
//"familyage": 23

class SickBean:Mappable {
    var familyid: Int = 0
    var usersickstateid:Int = 0
    var usersickseconddept:String?
    var familymale:String?
    var userorderid: Int = 0
    var familyname: String?
    var usersickpic:String?
    var usersicktime:String?
    var usersickid: Int = 0
    var usersickprimarydept:String?
    var usersickdesc: String?
    var familyage: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        familyid <- map["familyid"]
        usersickstateid <- map["usersickstateid"]
        usersickseconddept <- map["usersickseconddept"]
        familymale <- map["familymale"]
        userorderid <- map["userorderid"]
        familyname <- map["familyname"]
        usersickpic <- map["usersickpic"]
        usersicktime <- map["usersicktime"]
        usersickid <- map["usersickid"]
        usersickprimarydept <- map["usersickprimarydept"]
        usersickdesc <- map["usersickdesc"]
        familyage <- map["familyage"]
    }
    
}
// 交易记录
class MineTradeBean:Mappable {
    var payorderid:Int?
    var paymodename:String? // 支付方式
    var paycreattime:String? // 时间
    var paytotalamount:Double? // 金额
    var paysendername:String? // 收款人
    var paystatename:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        payorderid <- map["payorderid"]
        paymodename <- map["paymodename"]
        paycreattime <- map["paycreattime"]
        paytotalamount <- map["paytotalamount"]
        paystatename <- map["paystatename"]
        paysendername <- map["paysendername"]
    }
    
}
// 我的消息
class NotificationBean:Mappable {
    var notificationwords:String?
    var notificationid:Int?
    var notificationread:Bool?
    var notificationtitle:String?
    var notificationcreatetime:String?
    var notificationdata:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        notificationwords <- map["notificationwords"]
        notificationid <- map["notificationid"]
        notificationread <- map["notificationread"]
        notificationtitle <- map["notificationtitle"]
        notificationcreatetime <- map["notificationcreatetime"]
        notificationdata <- map["notificationdata"]
    }
    
}

// 我的 日程信息

class MineCalendarBean:Mappable {
    var doccalendarid = 0
    var doccalendaradressid = 0
    var docaddresslocation:String?
    var doccalendarday:String?
    var doccalendaraffair:String?
    var doccalendartime:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        doccalendarid <- map["doccalendarid"]
        doccalendaradressid <- map["doccalendaradressid"]
        docaddresslocation <- map["docaddresslocation"]
        doccalendarday <- map["doccalendarday"]
        doccalendaraffair <- map["doccalendaraffair"]
        doccalendartime <- map["doccalendartime"]
    }
}


