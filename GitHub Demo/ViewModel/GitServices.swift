
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
    case dashboard(param: [String: Any])
  
}

extension GitServices: TargetType{
    
    var baseURL: URL {
        return URL(string: AppConfig.baseUrl)!
   }
    
    public var path: String{
        switch self{
            
        case .login: return "login/oauth/access_token"
        case .dashboard: return "Dashboard"
           
        }
    }
    
    public var method: Moya.Method{
        
        return .post
        
//        switch self{
//        case .twilioVoiceToken(_):
//            return .get
//            
//        default :
//            return .post
//        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task{
        switch self{
            
        case .login(let param),
                .dashboard(let param)
            :
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
                     
        default :
            return .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        return nil
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
