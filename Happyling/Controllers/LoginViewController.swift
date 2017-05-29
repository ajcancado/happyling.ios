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
    
    @IBOutlet weak var showHidePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ""
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        setupTextFields()
    }
    
    func setupTextFields() {
        
        var addingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        addingView.contentMode = .center
        
        txUsername.leftView = addingView
        txUsername.leftViewMode = .always
        
        addingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        addingView.contentMode = .center
        
        txPassword.leftView = addingView
        txPassword.leftViewMode = .always
    }
        
    func validate() -> Bool {
        
        var flag = true
        
        if (txUsername.text?.isEmpty)! {
            txUsername.addError()
            flag = false
        }
        
        if (txPassword.text?.isEmpty)! {
            txPassword.addError()
            flag = false
        }
        
        return flag
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
                        
                        self.showAlertWithMessage(message: signInResponse!.responseAttrs.errorMessage!)
                        
                        print(signInResponse!.responseAttrs.errorMessage!)
                        
                    }

                case .failure(let error):
                    
                    self.showAlertWithMessage(message: error.localizedDescription)
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func forgottenPassword(){
        
        let alertController = UIAlertController(title: "Forgotten Password ?", message: "", preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "Recover", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields?.first
        
            var params: [String: Any] = [:]
            
            params["email"] = firstTextField?.text
            
            self.recoverPassword(params: params)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your email"
            textField.keyboardType = .emailAddress
        }
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func recoverPassword(params: [String: Any]){
        
        showHUD()
        
        Alamofire.request(SignInRouter.ForgottenPassword(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
            case .failure(let error):
                
                self.showAlertWithMessage(message: error.localizedDescription)
                
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func showHidePassword(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if button.isSelected {
            
            showHidePasswordButton.setImage(UIImage(named: "ic_eye_onbright_off"), for: .normal)
            txPassword.isSecureTextEntry = true
            button.isSelected = false
        }
        else{
            
            showHidePasswordButton.setImage(UIImage(named: "ic_eye_onbright_on"), for: .normal)
            txPassword.isSecureTextEntry = false
            button.isSelected = true
        }
    }
    
    func segueForSignUp() {
        
         performSegue(withIdentifier: "showSignUpView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        
        if section == 1 {
            makeLogin()
        }
        else if section == 2 {
            forgottenPassword()
        }
        else if section == 3 {
            segueForSignUp()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.removeError()
        
        return true
    }
}

