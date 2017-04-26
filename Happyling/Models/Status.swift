//
//  Status.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class Status: NSObject, Mappable {
    
    var id: Int!
    var name: String!
    
    init(id: Int, name: String){
        
        self.id = id
        self.name = name
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id                  <- map["id"]
        name                <- map["name"]
    }


}
