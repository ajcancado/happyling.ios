//
//  ThanksViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 02/05/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit

class ThanksViewController: GenericViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(back), userInfo: nil, repeats: false)
    }

    func back(){
        
        self.dismiss(animated: true, completion: nil)
    }

}
