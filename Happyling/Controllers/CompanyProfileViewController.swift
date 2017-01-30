//
//  CompanyProfileViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit

class CompanyProfileViewController: UIViewController {

    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = company.name
         
    }

    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }

}
