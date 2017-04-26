//
//  Issue.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class Issue: NSObject, Mappable {
    
    var id: Int!
    var subject: String!
    var descricao: String!
    var creationDate: Double!
    var updateDate: Double!
    var status: Status!
    var user: User!
    var company: Company!
    var type: IssueType!
    var currentInteraction: CurrentInteraction!
    var interactions: [Interaction]!
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id                      <- map["id"]
        subject                 <- map["subject"]
        descricao               <- map["description"]
        creationDate            <- map["creationDate"]
        updateDate              <- map["updateDate"]
        status                  <- map["status"]
        user                    <- map["user"]
        company                 <- map["company"]
        type                    <- map["type"]
        currentInteraction      <- map["currentInteraction"]
        interactions            <- map["interactions"]
        
    }
    
    
}
