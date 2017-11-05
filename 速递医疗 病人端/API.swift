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
    case getdoctorlist(Int, String, String) // 获取首页医生信息
    case getorder(Int, Int, Int) // 获取订单信息
    case addfamily(Int, String, String, Int) // 添加亲属
    case findfamily(Int) // 查询亲属
    case getredoctor // 获取我的医生
    case updateinfo(Data) // 上传图片
    case getsick(Int) // 获取病情
}
// 配置请求
extension API: TargetType {
    public var baseURL: URL { return URL(string: StaticClass.BaseApi)! }
    public var path: String {
        switch self {
        case .login:
            return "/login"
        case .phonetest:
            return "/phonetest"
        case .getcode:
            return "/getcode"
        case .register:
            return "/register"
        case .getdoctorlist:
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
            return  .requestParameters(parameters: ["userloginphone": user, "userloginpwd": pwd], encoding: URLEncoding.default)
        case .phonetest(let phone):
            return .requestParameters(parameters: ["userloginphone": phone], encoding: URLEncoding.default)
        case .getcode(let phone):
            return .requestParameters(parameters: ["userloginphone": phone], encoding: URLEncoding.default)
        case .register(let phone, let pwd, let code):
            return .requestParameters(parameters: ["userloginphone":phone, "userloginpwd": pwd, "code": code], encoding: URLEncoding.default)
        case .getdoctorlist(let page, let lon, let lat):
            return .requestParameters(parameters: ["page": page, "userloginlon": lon, "userloginlat":lat], encoding: URLEncoding.default)
        case .addfamily(let id, let name, let sex, let age):
            return .requestParameters(parameters: ["userloginid": id, "familyname": name, "familymale":sex, "familyage": age], encoding: URLEncoding.default)
        case .findfamily(let id):
            return .requestParameters(parameters: ["userloginid": id], encoding: URLEncoding.default)
        case .getorder(let page, let id, let type):
            switch type {
            case 0:
                return .requestParameters(parameters: ["page": page, "userloginid": id], encoding: URLEncoding.default)
                
            default:
                return .requestParameters(parameters: ["page": page, "userloginid": id, "type":type], encoding: URLEncoding.default)
            }
        case .getredoctor:
            return .requestParameters(parameters: ["userloginid":LOGINID!], encoding: URLEncoding.default)
    
        case .updateinfo(let data):
    return .uploadCompositeMultipart([MultipartFormData.init(provider: .data(data), name: "pictureFile", fileName: "photo.jpg", mimeType:"image/png")], urlParameters: ["userloginid": LOGINID!])
        case .getsick(let type):
            return .requestParameters(parameters: ["userloginid":LOGINID!, "type":type], encoding: URLEncoding.default)
        }
        
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
