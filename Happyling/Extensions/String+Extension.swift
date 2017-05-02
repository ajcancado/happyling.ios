//
//  String+Extension.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 02/05/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

extension String {
    
    func localized(lang:String) -> String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }

}
