//
//  User.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class User: NSObject, Mappable {
    
    var id: Int!
    var facebookID: String!
    var name: String!
    var surname: String!
    var email: String!
    var dateOfBirth: String!
    var phoneNumber: String!
    var mobileNumber: String!
    var gender: String!
    var identificationNumber: String!
    var postalCode: String!
    var city: String!
    var state: String!
    var country: String!
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id                          <- map["id"]
        facebookID                  <- map["facebookId"]
        name                        <- map["name"]
        surname                     <- map["surname"]
        email                       <- map["email"]
        dateOfBirth                 <- map["dateOfBirth"]
        phoneNumber                 <- map["phoneNumber"]
        mobileNumber                <- map["mobileNumber"]
        gender                      <- map["gender"]
        identificationNumber        <- map["identificationNumber"]
        postalCode                  <- map["postalCode"]
        city                        <- map["city"]
        state                       <- map["state"]
        country                     <- map["country"]
    }
    
}
