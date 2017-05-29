//
//  Double+Extension.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 02/05/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

extension Double {
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
    
    func toDate() -> Date {
        
        return NSDate(timeIntervalSince1970: self/1000.0) as Date!
    }
}

