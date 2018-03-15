//
//  WeChatAPI.swift


import Foundation
import Moya

// 创建请求
public enum API {
    case login(String, String) // 用户登录
    case phonetest(String) // 检查手机号码
    case getcode(String) // 发送短信验证码
    case register(String, String, String) // 注册
    case editpassword(String, String, String) // 重置密码
    case updatechannelid(Int,String)// 更新channelid
    case huanxinregister // 环信注册
    case getdoctorlist(Int, String, String) // 获取首页医生信息
    case doctorinfo(Int) // 获取医生详细信息
    case getdoctorlistByDept(Int,String,String,String,String)
    case getdoctorlistByLoc(Int,String,String,String,String, String)
    // 我的日程
    case getorder(Int, Int, Int) // 获取订单信息
    case cancelorder(Int) // 取消订单
    case addfamily(String, String, Int) // 添加亲属
    case deletefamily(Int) // 删除亲属
    case findfamily // 查询亲属
    case getredoctor(Int) // 获取我的医生
    case updateinfo(Data) // 上传头像
    case getsick(Int) // 获取病情
    case addsick([Data]?, String,String,String, Int) // 增加病情
    case publishsick(Int) // 发布病情
    case deletesick(Int) // 删除病情
    case cancelsick(Int) // 取消发布病情
    case editsick(Int, String) // 编辑病情
    case optdoctor(Int) // 预选医生
    case createorder(Int, Int) // 生成订单
    case createquickorder(Int, Int, Int) // 快速生成订单
    case getinfo // 获取个人信息
    case editinfo(String, String, [Data], String, Int, String) // 保存个人信息
    case exit // 退出登录
    case cancelhospital(Int) // 取消住院
    case payhospital(Int) // 支付住院押金
    case updatealipayaccount(String, String) // 修改支付宝账号
    case getalipayaccount // 获取支付宝账号
    case deleteallreceivenotification //删除通知
    // todo
    case gethistoryorder(Int) // 获取历史订单
    case listtraderecord(Int) // 获取交易记录
    case listreceivenotification(Int) // 获取消息记录
    case reviewinfo // 提交审核
    case confirmorder(Int, Int) // 病人确认订单
    case getcalendar(Int) // 获取医生日程
    case getevaluation(Int, Int) // 获取医生评价
    case evaluate(Int, Int, Int, Int, String) // 提交评价
    case getreviewinfo // 更新账号状态
    case updatelocation(String, String,String,String,String) // 更新用户位置信息
    case orderdetail(Int) // 订单详情
    case updatenotificationtoread(Int) // 更新已读状态
    case updateallnotificationtoread // 全部消息更新为已读
    
    case addfeedback(String) // 提交反馈
    case uploadId([Data]) // 上传身份证
    case mapdoctors(String, String) // 获取医生地图模式
    
}
// 配置请求
extension API: TargetType {
    public var baseURL: URL {
        switch self {
        case .addfeedback:
            return URL.init(string: StaticClass.BaseCommonAPI)!
        default:
            return URL(string: StaticClass.BaseApi)!
        }
    }
    public var path: String {
        switch self {
        case .deletefamily:
            return "/deletefamily"
        case .login:
            return "/login"
        case .phonetest:
            return "/phonetest"
        case .getcode:
            return "/getcode"
        case .register:
            return "/register"
        case .huanxinregister:
            return "/huanxinregister"
        case .getdoctorlist, .getdoctorlistByLoc, .getdoctorlistByDept:
            return "/listdoctors"
        case .getorder:
            return "/getorder"
        case .addfamily:
            return "/addfamily"
        case .findfamily:
            return "/findfamily"
        case .getredoctor:
            return "/getredoctor"
        case .updateinfo:
            return "/updateinfo"
        case .getsick:
            return "/getsick"
        case .addsick:
            return "/addsick"
        case .editsick:
            return "/editsick"
        case .publishsick:
            return "/publishsick"
        case .deletesick:
            return "/deletesick"
        case .optdoctor:
            return "/optdoctor"
        case .createorder:
            return "/createorder"
        case .cancelsick:
            return "/cancelsick"
        case .getcalendar:
            return "/getcalendar"
        case .updatechannelid:
            return "/updatechannelid"
        case .exit:
            return "/exit"
        case .confirmorder:
            return "/confirmorder"
        case .cancelorder:
            return "/cancelorder"
        case .editpassword:
            return "/editpassword"
        case .getinfo:
            return "/getinfo"
        case .editinfo, .uploadId:
            return "/editinfo"
        case .gethistoryorder:
            return "/gethistoryorder"
        case .listtraderecord:
            return "/listtraderecord"
        case .listreceivenotification:
            return "/listreceivenotification"
        case .getevaluation:
            return "/getevaluation"
        case .evaluate:
            return "/evaluate"
        case .deleteallreceivenotification:
            return "/deleteallreceivenotification"
        case .reviewinfo:
            return "/reviewinfo"
        case .doctorinfo:
            return "/doctorinfo"
            
        case .updatealipayaccount:
            return "/updatealipayaccount"
        case .getalipayaccount:
            return "/getalipayaccount"
        case .getreviewinfo:
            return "/getreviewinfo"
        case .orderdetail:
            return "/orderdetail"
        case .cancelhospital:
            return "/cancelhospital"
        case .payhospital:
            return "/payhospital"
        case .updatelocation:
            return "/updatelocation"
        case .updatenotificationtoread:
            return "/updatenotificationtoread"
        case .updateallnotificationtoread:
            return "/updateallnotificationtoread"
        case .createquickorder:
            return "/createquickorder"
        case .addfeedback:
            return "/addfeedback"
        case .mapdoctors:
            return "/mapdoctors"
        }
    }
    public var method: Moya.Method {
        return .post
    }
    
    
    public var sampleData: Data {
        return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    }
    public var task: Moya.Task {
        
        switch self {
        case .login(let user, let pwd):
            return  .requestParameters(parameters: ["userloginphone": user, "userloginpwd": pwd, "userlogindev":2], encoding: URLEncoding.default)
        case .phonetest(let phone):
            return .requestParameters(parameters: ["userloginphone": phone], encoding: URLEncoding.default)
        case .getcode(let phone):
            return .requestParameters(parameters: ["userloginphone": phone], encoding: URLEncoding.default)
        case .register(let phone, let pwd, let code):
            return .requestParameters(parameters: ["userloginphone":phone, "userloginpwd": pwd, "code": code], encoding: URLEncoding.default)
        case .editpassword(let phone, let pwd, let code):
            return .requestParameters(parameters: ["userloginphone":phone, "userloginpwd": pwd, "code": code], encoding: URLEncoding.default)
        case .updatechannelid(let id, let channelid):
            return .requestParameters(parameters: ["userloginid":id, "channelid":channelid], encoding: URLEncoding.default)
        case .huanxinregister:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userloginpwd": user_default.password.getStringValue()!], encoding: URLEncoding.default)
        case .getdoctorlist(let page, let lon, let lat):
            return .requestParameters(parameters: ["page": page, "userloginlon": lon, "userloginlat":lat], encoding: URLEncoding.default)
        case .getdoctorlistByDept(let page, let lon, let lat, let onedept, let twodept):
            return .requestParameters(parameters: ["page": page, "userloginlon": lon, "userloginlat":lat, "docprimarydept":onedept, "docseconddept":twodept,"type":1], encoding: URLEncoding.default)
        case .getdoctorlistByLoc(let page, let lon, let lat, let province, let city,let area):
            return .requestParameters(parameters: ["page": page, "userloginlon": lon, "userloginlat":lat, "dochospprovince":province, "dochospcity":city, "dochosparea":area,"type":2], encoding: URLEncoding.default)
        case .addfamily(let name, let sex, let age):
            return .requestParameters(parameters: ["userloginid": Int(user_default.userId.getStringValue()!), "familyname": name, "familymale":sex, "familyage": age], encoding: URLEncoding.default)
        case .findfamily:
            return .requestParameters(parameters: ["userloginid": Int(user_default.userId.getStringValue()!)], encoding: URLEncoding.default)
        case .getorder(let page, let id, let type):
            switch type {
            case 0:
                return .requestParameters(parameters: ["page": page, "userloginid": id], encoding: URLEncoding.default)
                
            default:
                return .requestParameters(parameters: ["page": page, "userloginid": id, "type":type], encoding: URLEncoding.default)
            }
        case .getredoctor(let page):
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!,"page":page], encoding: URLEncoding.default)
            
        case .updateinfo(let data):
            return .uploadCompositeMultipart([MultipartFormData.init(provider: .data(data), name: "pictureFile", fileName: "photo.jpg", mimeType:"image/png")], urlParameters: ["userloginid": Int(user_default.userId.getStringValue()!)!])
        case .getsick(let type):
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!, "type":type], encoding: URLEncoding.default)
        case .addsick(let datas, let desc, let onedept, let twodept,let familyid):
            var formDatas = [MultipartFormData.init(provider: .data(Data.init()), name: "pictureFile")]
            if datas != nil {
                formDatas = [MultipartFormData]()
                for (i, data) in datas!.enumerated() {
                    let formData = MultipartFormData.init(provider: .data(data), name: "pictureFile", fileName: "test\(i).jpg", mimeType: "image/png")
                    formDatas.append(formData)
                }
            }
            return .uploadCompositeMultipart(formDatas, urlParameters: ["usersickdesc": desc, "usersickprimarydept":onedept, "usersickseconddept": twodept,"userloginid":Int(user_default.userId.getStringValue()!)!, "familyid": familyid])
        case .publishsick(let sick):
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!, "usersickid":sick], encoding: URLEncoding.default)
        case .deletesick(let sick):
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!, "usersickid":sick], encoding: URLEncoding.default)
        case .cancelsick(let sick):
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!, "usersickid":sick], encoding: URLEncoding.default)
        case .editsick(let sickID, let desc):
            let formDatas = [MultipartFormData.init(provider: .data(Data.init()), name: "pictureFile")]
            return .uploadCompositeMultipart(formDatas, urlParameters: ["usersickid":sickID, "usersickdesc":desc, "userloginid":Int(user_default.userId.getStringValue()!)!])
        case .optdoctor(let doctorId):
            return .requestParameters(parameters: ["docloginid":doctorId, "userloginid":Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .createorder(let docId, let calendarid):
            return .requestParameters(parameters: ["docloginid":docId, "doccalendarid":calendarid, "userloginid": Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .exit:
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .getcalendar(let doctorId):
            return .requestParameters(parameters: ["docloginid":doctorId], encoding: URLEncoding.default)
        case .cancelorder(let orderId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userorderid":orderId], encoding: URLEncoding.default)
        case .confirmorder(let orderId, let type):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userorderid":orderId, "type":type], encoding: URLEncoding.default)
        case .createquickorder(let docId, let calenderId, let paytype):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "docloginid":docId, "paytype":paytype, "doccalendarid":calenderId], encoding: URLEncoding.default)
        case .getinfo:
            return .requestParameters(parameters: ["userloginid":Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .editinfo(let name, let card, let datas, let male, let age, let address):
            var formDatas = [MultipartFormData]()
            for (i, data) in datas.enumerated() {
                let formData = MultipartFormData.init(provider: .data(data), name: "usercardphoto", fileName: "picture\(i).jpg", mimeType: "image/png")
                formDatas.append(formData)
            }
            return .uploadCompositeMultipart(formDatas, urlParameters: ["userloginid": Int(user_default.userId.getStringValue()!)!, "username":name, "usermale":male, "usercardnum":card, "useradrother":address, "userage":age])
            
        case .gethistoryorder(let page):
            return .requestParameters(parameters: ["page": page, "userloginid": Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .listtraderecord(let page):
            return .requestParameters(parameters: ["page": page, "userloginid": Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .listreceivenotification(let page):
            return .requestParameters(parameters: ["page": page,"userloginid": Int(user_default.userId.getStringValue()!)!], encoding: URLEncoding.default)
        case .getevaluation(let page, let doctorId):
            return .requestParameters(parameters: ["page": page,"docloginid": doctorId], encoding: URLEncoding.default)
        case .evaluate(let orderId, let doccommentservicelevel,let  doccommentprofessionallevel,let doccommentpricelevel, let doccommentwords):
            return .requestParameters(parameters: ["userorderid": orderId,"userloginid": Int(user_default.userId.getStringValue()!)!,"doccommentservicelevel":doccommentservicelevel, "doccommentprofessionallevel":doccommentprofessionallevel, "doccommentpricelevel":doccommentpricelevel, "doccommentwords":doccommentwords], encoding: URLEncoding.default)
        case .deleteallreceivenotification:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .reviewinfo:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .doctorinfo(let id):
            return .requestParameters(parameters: ["docloginid":id, "userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .updatealipayaccount(let account, let name):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "alipayaccount":account, "alipayname": name], encoding: URLEncoding.default)
        case .getalipayaccount:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .deletefamily(let familyId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "familyid":familyId], encoding: URLEncoding.default)
        case .getreviewinfo:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .orderdetail(let orderId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userorderid":orderId], encoding: URLEncoding.default)
        case .cancelhospital(let orderId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userorderid":orderId], encoding: URLEncoding.default)
        case .payhospital(let orderId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userorderid":orderId, "type":1], encoding: URLEncoding.default)
        case .updatelocation(let lon, let lat, let province, let city, let area):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "userloginlon":lon, "userloginlat":lat, "userloginprovince":province,"userlogincity":city,"userloginarea":area], encoding: URLEncoding.default)
        case .updatenotificationtoread(let msgId):
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!, "notificationid":msgId], encoding: URLEncoding.default)
        case .updateallnotificationtoread:
            return .requestParameters(parameters: ["userloginid":user_default.userId.getStringValue()!], encoding: URLEncoding.default)
        case .addfeedback(let str):
            return .requestParameters(parameters: ["type":3, "feedbackidea":str], encoding: URLEncoding.default)
        case .uploadId(let datas):
            var formDatas = [MultipartFormData]()
            for (i, data) in datas.enumerated() {
                let formData = MultipartFormData.init(provider: .data(data), name: "usercardphoto", fileName: "picture\(i).jpg", mimeType: "image/png")
                formDatas.append(formData)
            }
            return .uploadCompositeMultipart(formDatas, urlParameters: ["userloginid": Int(user_default.userId.getStringValue()!)!])
        case .mapdoctors(let lon, let lat):
            return .requestParameters(parameters: ["userloginlon":lon, "userloginlat":lat], encoding: URLEncoding.default)
        }
        
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
