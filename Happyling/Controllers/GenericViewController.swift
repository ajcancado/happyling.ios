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

        // Do any additional setup after loading the view.
    }

    func showHUD() {
        
        HUD.show(.progress)
    }
    
    func hideHUD() {
        
        HUD.hide()
    }

}
