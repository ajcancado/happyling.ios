//
//  DateHelper.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 28/05/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

class DateHelper {

    static func formatDate(date: Date, withFormat format:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date as Date)
        
    }
}
