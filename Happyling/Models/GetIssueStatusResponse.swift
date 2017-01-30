//
//  GetIssueStatusResponse.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 30/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import UIKit
import ObjectMapper

class GetIssueStatusResponse: Mappable {
    
    var data: [Status]!
    var responseAttrs: ResponseAttrs!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data                <- map["data"]
        responseAttrs       <- map["responseAttrs"]
        
    }
    
}
