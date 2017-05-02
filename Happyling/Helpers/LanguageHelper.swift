//
//  LanguageHelper.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 02/05/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

class LanguageHelper: NSObject {
    
    static func getLanguage() -> String {
        
        let pre = NSLocale.preferredLanguages.first
        
        if pre!.contains("de") {
            
            return "de_DE"
        }
        else if pre!.contains("pt") {
            
            return "pt_BR"
        }
        
        return "en_US"
        
    }

}
