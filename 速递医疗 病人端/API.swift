//
//  WeChatAPI.swift


import Foundation
import Moya

// 创建请求
public enum WeChat {
    case getNewsListByPage(Int, Int) // 根据page 获取新闻列表
}
// 配置请求
extension WeChat: TargetType {
    public var baseURL: URL { return URL(string: StaticClass.BaseApi)! }
    public var path: String {
        switch self {
        case .getNewsListByPage:
            return "/wxnew"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    
    
    public var sampleData: Data {
        switch self {
        case .getNewsListByPage:
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        }
    }
    public var task: Moya.Task {
        
        switch self {
        case .getNewsListByPage(let page, let pagesize):
           return  .requestParameters(parameters: ["key":StaticClass.APIKey, "page": page, "num": pagesize], encoding: URLEncoding.default)
        }
    }
    
    public var validate: Bool {
        return false
    }
    public var headers: [String : String]? {
        return nil
    }
    
}
