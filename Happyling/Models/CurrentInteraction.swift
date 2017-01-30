//
//  CurrentInteraction.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class CurrentInteraction: NSObject, Mappable {
    
    var attachments: [Attachment]!
    
    override init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        attachments                 <- map["attachments"]
    }
}
