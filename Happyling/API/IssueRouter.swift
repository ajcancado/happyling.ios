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
    
    case GetIssues(Int, [Int])
    case GetIssueDescription(Int)
    case GetIssueTypes
    case GetIssueStatus
    case MakeIssueReport([String: Any])
    case MakeIssueInteraction([String: Any])
    case MakeIsseuReportRating([String: Any])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetIssues:
            return .get
        case .GetIssueDescription:
            return .get
        case .GetIssueTypes:
            return .get
        case .GetIssueStatus:
            return .get
        case .MakeIssueReport:
            return .post
        case .MakeIssueInteraction:
            return .post
        case .MakeIsseuReportRating:
            return .post
        }
    }
    
    var path: String {
        switch self {
            
        case .GetIssues(let userId, let statusIds):
            
            var string = "issue-report?userId=\(userId)"
            
            for statusId in statusIds{
                
                string = string + "&statusId=\(statusId)"
            }
            
            return string
            
        case .GetIssueDescription(let issueID):
            return "issue-report/\(issueID)"
        case .GetIssueTypes:
            return "issue-report/types"
        case .GetIssueStatus:
            return "issue-report/status"
        case .MakeIssueReport:
            return "issue-report"
        case .MakeIssueInteraction:
            return "issue-report-interaction/user"
        case .MakeIsseuReportRating:
            return "issue-report-rating"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
    
        let fullUrl = Constants.API.baseURL + "/" + path
        
        var urlRequest = URLRequest(url: URL(string: fullUrl)!)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(LanguageHelper.getLanguage(), forHTTPHeaderField: "x-user-lang")
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if userId != Constants.SessionKeys.guestUserId {
            urlRequest.setValue("\(userId)", forHTTPHeaderField: "x-user-id")
        }
        
        switch self {
            
        case .GetIssues(_, _):

            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
            
        case .MakeIssueReport(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .MakeIssueInteraction(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .MakeIsseuReportRating(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        
        default:
            return urlRequest
        }
    }
}
