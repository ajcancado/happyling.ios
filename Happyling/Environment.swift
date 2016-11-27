//
//  Environment.swift
//  PostBeyond
//
//  Created by Heberti Almeida on 4/7/16.
//  Copyright © 2016 PostBeyond Inc. All rights reserved.
//

import UIKit

enum Environment: Int {
    case Development
    case Production
}

extension Environment {
    
    static var current: Environment {
        
        get {
            return Environment(rawValue: UserDefaults.standard.integer(forKey: Constants.DefaultKey.environment))!
        }
        set (val) {
            UserDefaults.standard.set(val.hashValue, forKey: Constants.DefaultKey.environment)
        }
    }
}   
