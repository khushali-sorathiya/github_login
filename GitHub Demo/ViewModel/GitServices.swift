
//
//  GitServices.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//


import Foundation
import Moya

enum GitServices{
    
    case login(param: [String: Any])
    case dashboard(page: Int, perPage: Int)
  
}

extension GitServices: TargetType{
   
    var baseURL: URL {
        switch self{
        case .dashboard: return URL(string: AppConfig.repobaseURL)!
        default :
            return URL(string: AppConfig.baseUrl)!
        }
        
   }
    
    public var path: String{
        switch self{
            
        case .login: return "login/oauth/access_token"
        case .dashboard: return "user/repos"
           
        }
    }
    
    public var method: Moya.Method{
        
        switch self{
        case .dashboard:
            return .get
            
        default :
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task{
        switch self{
        case .dashboard(let page, let perPage):
                    return .requestParameters(
                        parameters: ["page": page, "per_page": perPage],
                        encoding: URLEncoding.queryString
                    )
                
        case .login(let param) :
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        default :
            return .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        if udf.accessToken().isEmpty {
            return nil
        }
        return ["Authorization": "Bearer \(udf.accessToken())"]
    }
}

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
