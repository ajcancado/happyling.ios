//
//  CompanyRouter.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire

enum CompanyRouter: URLRequestConvertible{
    
    case GetCompany([String: Any])
    case GetCompanyCategories()
    case MakeCompany([String: Any])
    case MakeCompanySimple([String: Any])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetCompany:
            return .get
        case .GetCompanyCategories:
            return .get
        case .MakeCompany:
            return .post
        case .MakeCompanySimple:
            return .post
        }
    }
    
    var path: String {
        switch self {
            
        case .GetCompany:
            return "company"
        case .GetCompanyCategories:
            return "company-categories/all"
        case .MakeCompany:
            return "company"
        case .MakeCompanySimple:
            return "company/simple"
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
            case .GetCompany(let parameters):
                return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            case .MakeCompany(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            case .MakeCompanySimple(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            default:
                return urlRequest
        }
    }
}
