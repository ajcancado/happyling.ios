//
//  GetIssueDescriptionResponse.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 25/07/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class GetIssueDescriptionResponse: Mappable {
    
    var data: Issue!
    var responseAttrs: ResponseAttrs!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data                <- map["data"]
        responseAttrs       <- map["responseAttrs"]
        
    }
    
}
