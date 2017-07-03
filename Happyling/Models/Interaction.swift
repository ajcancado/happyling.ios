//
//  Interaction.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class Interaction: NSObject, Mappable {
    
    var id: Int!
    var descricao: String!
    var date: Date!
    var owner: String!
    var issueReport: Int!
    var attachments: [Attachment]!
    var issueReportId: Int!
    
    override init(){}
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id                  <- map["id"]
        descricao           <- map["description"]
        date                <- (map["date"], DateTransform())
        owner               <- map["owner"]
        issueReport         <- map["issueReport"]
        attachments         <- map["attachments"]
        issueReportId       <- map["issueReportId"]
        
    }
    
    
}
