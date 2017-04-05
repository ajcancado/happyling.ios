//
//  IssueReportDTO.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class IssueReportDTO: NSObject, Mappable {
    
    
    var user: Int!
    var company: Int!
    var type: Int!
    var subject: String!
    var descricao: String!
    var currentInteraction: CurrentInteraction!
    
    override init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        user                        <- map["user"]
        company                     <- map["company"]
        type                        <- map["type"]
        subject                     <- map["subject"]
        descricao                   <- map["description"]
        currentInteraction          <- map["currentInteraction"]
    }
    
    

}
