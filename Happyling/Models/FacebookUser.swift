//
//  FacebookUser.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class FacebookUser: NSObject, Mappable {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var name: String!
    var email: String!
    var pictureUrl: String!
    
    required init?(map: Map) {
    
    }
    
    // Mappable
    func mapping(map: Map) {
    
        id                          <- map["id"]
        firstName                   <- map["first_name"]
        lastName                    <- map["last_name"]
        name                        <- map["name"]
        email                       <- map["email"]
        pictureUrl                  <- map["picture.data.url"]
    
    }


}
