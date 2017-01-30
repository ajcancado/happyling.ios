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
            return "/user/change-pass"
        }
    }    
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
    
        
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
