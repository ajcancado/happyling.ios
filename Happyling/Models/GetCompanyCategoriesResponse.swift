//
//  GetCompanyCategoriesResponse.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class GetCompanyCategoriesResponse: Mappable {
    
    var data: [CompanyCategorie]!
    var responseAttrs: ResponseAttrs!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data                <- map["data"]
        responseAttrs       <- map["responseAttrs"]
        
    }
        
}
