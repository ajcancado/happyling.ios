//
//  CompanyCategorie.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class CompanyCategorie: NSObject , Mappable {
    
    var id: Int!
    var name: String!
    var primaryKey: Int!

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id                          <- map["id"]
        name                        <- map["name"]
        primaryKey                  <- map["primaryKey"]
        
    }

}
