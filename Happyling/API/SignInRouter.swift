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
    
    case MakeLoginEmail([String: Any])
    case MakeLoginFacebook([String: Any])
    case ForgottenPassword()
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .MakeLoginEmail:
            return .post
        case .MakeLoginFacebook:
            return .post
        case .ForgottenPassword:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .MakeLoginEmail:
            return "login/authenticate"
        case .MakeLoginFacebook:
            return "login/face-authenticate"
        case .ForgottenPassword:
            return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            case .MakeLoginEmail(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            case .MakeLoginFacebook(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            default:
                return urlRequest
            
        }
    }
}
