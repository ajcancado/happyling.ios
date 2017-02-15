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

class LoginViewController: GenericTableViewController {
    
    @IBOutlet weak var txUsername: UITextField!
    @IBOutlet weak var txPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    func validate() -> Bool {
        
        if (txUsername.text?.isEmpty)! {
           
            return false
        }
        
        if (txPassword.text?.isEmpty)! {
            return false
        }
        
        
        return true
    }
    
    func makeLogin() {
        
        if validate() {
            
            showHUD()
            
            var params: [String: Any] = [:]
            
            params["username"] = txUsername.text
            params["pass"] = txPassword.text
            
            Alamofire.request(SignInRouter.MakeLoginEmail(params)).responseJSON { response in
                
                self.hideHUD()
                
                switch response.result {
                    
                case .success(let json):
                    
                    print(json)
                    
                    let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                    
                    if signInResponse?.data != nil {
                        
                        SessionManager.setInteger(int: (signInResponse?.data)!, forKey: Constants.SessionKeys.userId)
                        
                        SessionManager.setBool(bool: false, forKey: Constants.SessionKeys.isFromFacebook)
                        
                        self.segueToMainStoryboard()
                        
                    }
                    else if signInResponse?.responseAttrs.errorMessage != nil {
                        
                        print(signInResponse?.responseAttrs.errorMessage!)
                        
                    }

                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
                
            }

        }
        
    }
    
    func segueForSignUp() {
        
         performSegue(withIdentifier: "showSignUpView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            segueForSignUp()
        }
        else if section == 2 {
            makeLogin()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

