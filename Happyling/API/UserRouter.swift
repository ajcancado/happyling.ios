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
    
    case CreateUser([String: Any])
    case ReadUser(String)
    case UpdateUser(String, [String: Any])
    case DestroyUser(String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .CreateUser:
            return .post
        case .ReadUser:
            return .get
        case .UpdateUser:
            return .put
        case .DestroyUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .CreateUser:
            return "/user"
        case .ReadUser(let username):
            return "/user/\(username)"
        case .UpdateUser(let username, _):
            return "/user\(username)"
        case .DestroyUser(let username):
            return "/user/\(username)"
        }
    }


    
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
    
        
        switch self {
        case .CreateUser(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .UpdateUser(_, let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return urlRequest
        }
    }
}
