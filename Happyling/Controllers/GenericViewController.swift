//
//  GenericViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 27/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import PKHUD

class GenericViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showHUD() {
        
        HUD.show(.progress)
    }
    
    func hideHUD() {
        
        HUD.hide()
    }

    func segueToMainStoryboard(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func encodeBase64(image: UIImage) -> String{
        
        return (UIImagePNGRepresentation(image)?.base64EncodedString(options: .endLineWithLineFeed))!
    }
    
}
