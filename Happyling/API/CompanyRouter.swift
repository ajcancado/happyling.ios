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
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetCompany:
            return .get
        case .GetCompanyCategories:
            return .get
        case .MakeCompany:
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
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        switch self {
            case .GetCompany(let parameters):
                return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            case .MakeCompany(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            default:
                return urlRequest
        }
    }
}
