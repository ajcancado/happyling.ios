//
//  GetCompanyResponse.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class GetCompanyResponse: Mappable {
    
    var data: [Company]!
    var responseAttrs: ResponseAttrs!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data                <- map["data"]
        responseAttrs       <- map["responseAttrs"]
        
    }
    
}
