//
//  Company.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import ObjectMapper

class Company: NSObject , Mappable {
    
    var id: Int!
    var businessPerson: String!
    var name: String!
    var categorie: CompanyCategorie!
    var email: String!
    var emailNotifications: String!
    var phoneNumber: String!
    var postalCode: String!
    var identificationNumber: String!
    var webSite: String!
    var city: String!
    var state: String!
    var country: String!
    var average: Double!
    var status: String!
    
    override init() {
    
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        businessPerson              <- map["businessPerson"]
        categorie                   <- map["category"]
        city                        <- map["city"]
        country                     <- map["country"]
        email                       <- map["email"]
        emailNotifications          <- map["emailNotifications"]
        id                          <- map["id"]
        identificationNumber        <- map["identificationNumber"]
        name                        <- map["name"]
        phoneNumber                 <- map["phoneNumber"]
        postalCode                  <- map["postalCode"]
        state                       <- map["state"]
        average                     <- map["average"]
        status                      <- map["status"]
        webSite                     <- map["webSite"]
    }
    
    func validateAverageImage() -> UIImage{
        
        var averageImage: UIImage!
        
        if self.average != nil {
            
            if self.average > 4 {
                averageImage = UIImage(named: "ic_orange")
            }
            else if self.average > 3 {
                averageImage = UIImage(named: "ic_yellow_dark")
            }
            else if self.average > 2 {
                averageImage = UIImage(named: "ic_yellow")
            }
            else if self.average > 1 {
                averageImage = UIImage(named: "ic_blue")
            }
            else {
                averageImage = UIImage(named: "ic_purple")
            }
        }
        else {
            averageImage = UIImage(named: "ic_orange")
        }
        
        return averageImage
    }
}
