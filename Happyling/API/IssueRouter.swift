//
//  IssueRouter.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire

enum IssueRouter: URLRequestConvertible{
    
    case GetIssues([String: Any])
    case GetIssueTypes
    case GetIssueStatus
    case MakeIssueReport([String: Any])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetIssues:
            return .get
        case .GetIssueTypes:
            return .get
        case .GetIssueStatus:
            return .get
        case .MakeIssueReport:
            return .post
        }
    }
    
    var path: String {
        switch self {
            
        case .GetIssues:
            return "issue-report"
        case .GetIssueTypes:
            return "issue-report/types"
        case .GetIssueStatus:
            return "issue-report/status"
        case .MakeIssueReport:
            return "issue-report"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: Constants.API.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        switch self {
        case .GetIssues(let parameters):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        case .MakeIssueReport(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return urlRequest
        }
    }
}
