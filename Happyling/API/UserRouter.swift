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
    
    static let baseURLString = "http://localhost:8080/happyling-web"
    static var OAuthToken: String?
    
    case CreateUser([String: AnyObject])
    case ReadUser(String)
    case UpdateUser(String, [String: AnyObject])
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
        let url = URL(string: UserRouter.baseURLString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = UserRouter.OAuthToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
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
