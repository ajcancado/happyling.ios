//
//  ViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class LoginViewController: GenericViewController {
    
    @IBOutlet weak var txUsername: UITextField!
    @IBOutlet weak var txPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func validate() -> Bool {
        
        
        return true
    }
    
    @IBAction func makeLogin(_ sender: Any) {
        
        if validate() {
            
            showHUD()
            
            var params: [String: Any] = [:]
            
            params["username"] = txUsername.text
            params["pass"] = txUsername.text
            
            Alamofire.request(SignInRouter.MakeLogin(params)).responseJSON { response in
                
                self.hideHUD()
                
                switch response.result {
                    
                case .success(let json):
                    
                    
                    let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                    
            
                    if signInResponse?.responseAttrs.errorMessage != nil {
                        
                        
                        
                    }
                    else{
                        
                        
                        
                        
                    }

                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
                
            }

        }
        
    }
    
    @IBAction func segueForSignUp(_ sender: Any) {
        
         performSegue(withIdentifier: "showSignUpView", sender: self)
        
    }
    
}

