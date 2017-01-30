//
//  ResponseAttrs.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 27/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class ResponseAttrs: Mappable {
    
    var errorMessage: String!
    var recordsTotal: Int!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        errorMessage                <- map["errorMessage"]
        recordsTotal                <- map["recordsTotal"]
        
    }
    
}
