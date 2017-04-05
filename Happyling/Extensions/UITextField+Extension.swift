//
//  UITextField+Extension.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/03/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

extension UITextField {
    
    func isEmpty() -> Bool {
        
        if self.text == "" {
            return true;
        }
        
        return false;
    }
    
    func addError(){
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
    
    func removeError(){
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = false
        
    }
}
