//
//  GenericTableViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import PKHUD

class GenericTableViewController: UITableViewController {
    
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
    
    func showAlertWithMessage(message: String) {
        
        let alertController = UIAlertController(title: "Happyling", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

