//
//  Constants.swift
//  PostBeyond
//
//  Created by Heberti Almeida on 4/7/16.
//  Copyright © 2016 PostBeyond Inc. All rights reserved.
//

import UIKit

struct Constants {
    
    struct API {
        static var baseURL: String {
            switch Environment.current {
            case .Development:
                return "http://app.happyling.de:8080/happyling-web/app"
            case .Production:
                return "http://app.happyling.de:8080/happyling-web/app"
            }
        }
    }
    
    struct SessionKeys {
        
        static let environment = "environment"
        
        static let userId = "userID"
        static let isFromFacebook = "isFromFacebook"
    
        static let deviceToken = "deviceToken"
        
        static let guestUserId = -1
    }
    
    struct Colors {
        
        static let purple = UIColor(red: 102.0/255.0, green: 45.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        
        static let pink = UIColor(red: 194.0/255.0, green: 106.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        
        static let yellow = UIColor(red: 252.0/255.0, green: 193.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        static let beige = UIColor(red: 175.0/255.0, green: 180.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        
        static let blueOther = UIColor(red: 35.0/255.0, green: 178.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        static let NavigationBarColor = UIColor(red: 47.0/255.0, green: 52.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        
        static let TitleColor = UIColor(red: 0.0, green: 162.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        
        static let gray = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        
        static let blue = UIColor(red: 14.0/255.0, green: 105.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        
        //#E66C1F
        static let orange = UIColor(red: 230.0/255.0, green: 108.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        
    }
    
    struct NotificationKeys {
        
        static let newInteraction = "NEW_INTERACTION"
        
    }

    
    struct Path {
        static let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let tmp = NSTemporaryDirectory()
        static let bundlePath = Bundle.main.bundlePath
        static let bundle = Bundle.main
    }
}
