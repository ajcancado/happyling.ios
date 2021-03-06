//
//  UserRouter.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire

enum UserRouter: URLRequestConvertible{
    
    case GetUser(userID: Int)
    case CreateUser([String: Any])
    case CreateUserSimple([String: Any])
    case CreateUserFacebook([String: Any])
    case ReadUser(String)
    case UpdateUser([String: Any])
    case UpdatePass([String: Any])
    case UpdateToken(Int,String)
    case DeleteToken(Int)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetUser:
            return .get
        case .CreateUser:
            return .post
        case .CreateUserSimple:
            return .post
        case .CreateUserFacebook:
            return .post
        case .ReadUser:
            return .get
        case .UpdateUser:
            return .put
        case .UpdatePass:
            return .put
        case .UpdateToken:
            return .put
        case .DeleteToken:
            return .delete
        }
    }
    
    var path: String {
        switch self {
            
        case .GetUser(let userID):
            return "user/\(userID)"
        case .CreateUser:
            return "user"
        case .CreateUserSimple:
            return "user/simple"
        case .CreateUserFacebook:
            return "user/facebook"
        case .ReadUser(let username):
            return "user/\(username)"
        case .UpdateUser:
            return "user"
        case .UpdatePass:
            return "user/change-pass"
        case .UpdateToken(let id, let token):
            return "user/change-device-token/\(id)/\(token)"
        case .DeleteToken(let id):
            return "user/remove-device-token/\(id)"
            
        }
    }    
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(LanguageHelper.getLanguage(), forHTTPHeaderField: "x-user-lang")
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if userId != Constants.SessionKeys.guestUserId {
            urlRequest.setValue("\(userId)", forHTTPHeaderField: "x-user-id")
        }
        
        switch self {
        case .CreateUser(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .CreateUserSimple(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .CreateUserFacebook(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .UpdateUser(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .UpdatePass(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return urlRequest
        }
    }
}
