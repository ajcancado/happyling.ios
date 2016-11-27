//
//  SignInRouter.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 27/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire

enum SignInRouter: URLRequestConvertible{
    
    case MakeLogin([String: Any])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .MakeLogin:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .MakeLogin:
            return "/login/authenticate"
        }
    }
    
    
    
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        switch self {
        case .MakeLogin(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)

        default:
            return urlRequest
        }
    }
}
