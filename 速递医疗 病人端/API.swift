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
        }
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
