//
//  Attachment.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class Attachment: NSObject, Mappable {

    var name: String!
    var encodingData: String!
    
    override init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        name                        <- map["name"]
        encodingData                <- map["encodingData"]
        
    }
    
}
