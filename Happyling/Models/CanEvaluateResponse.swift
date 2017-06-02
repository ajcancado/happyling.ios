//
//  CanEvaluateResponse.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 01/06/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class CanEvaluateResponse: Mappable {
    
    var data: Bool!
    var responseAttrs: ResponseAttrs!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data                <- map["data"]
        responseAttrs       <- map["responseAttrs"]
        
    }
    
}
