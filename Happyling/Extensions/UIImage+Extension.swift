//
//  UIImage+Extension.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

extension UIImage {
    
    func encodeToBase64String() -> String{
        
        let imageData:NSData = UIImagePNGRepresentation(self)! as NSData
        
        
        return imageData.base64EncodedString(options: .endLineWithLineFeed)
        
//        return (UIImagePNGRepresentation(self)?.base64EncodedString(options: .endLineWithLineFeed))!
    }
    
}
