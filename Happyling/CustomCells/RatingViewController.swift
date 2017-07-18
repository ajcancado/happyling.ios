//
//  RatingViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 20/04/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import AARatingBar
import Alamofire

class RatingViewController: GenericViewController {

    var issue: Issue!
    
    @IBOutlet weak var rating: AARatingBar!
    
    @IBOutlet weak var isResolvedSwitch: UISwitch!
    
    @IBOutlet weak var isResolvedLabel: UILabel!
    
    @IBOutlet weak var txtAvaliation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isResolvedLabel.text = "Your problem is resolved ?"
        
        isResolvedSwitch.onTintColor = Constants.Colors.orange
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sendRating(_ sender: Any) {
                
        self.showHUD()
        
        var params: [String: Any] = [:]
        
        params["comment"] = txtAvaliation.text
        params["value"] = Int.init(rating.value)
        params["issueReport"] = issue.id
        params["isResolved"] = isResolvedSwitch.isOn
        
        Alamofire.request(IssueRouter.MakeIsseuReportRating(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print("Sucesso !!! \(json)")
                
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }

        
    }

}
