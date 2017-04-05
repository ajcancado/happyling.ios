//
//  SignUpViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class SignUpTableViewController: UITableViewController{

    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var txName: UITextField!
    @IBOutlet var txEmail: UITextField!
    @IBOutlet var txPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SignUp"
        
        updateWidthsForLabels(labels: labels)
        
        setupTableView()
    }
    
    func setupTableView(){
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        
        return labelSize.width
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        
    
        return 74//reduce(map(labels, calculateLabelWidth), 0, max)
    }
    
    private func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    func makeSignUp() {
        
        if validate() {
            
            var params: [String: Any] = [:]
            
            params["name"] = txName.text
            params["email"] = txEmail.text
            params["password"] = txPassword.text
            params["confirmPassword"]  = txPassword.text
            
            if SessionManager.containsObjectForKey(key: Constants.SessionKeys.deviceToken) { 
                params["deviceToken"] = SessionManager.getObjectForKey(key: Constants.SessionKeys.deviceToken)
            }
            
            print(params)
            
            Alamofire.request(UserRouter.CreateUserSimple(params)).responseJSON { response in
                
                
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
    
    func validate() -> Bool {
        
        var flag = true
        
        if (txName.text?.isEmpty)! {
            txName.addError()
            flag = false
        }
        
        if (txEmail.text?.isEmpty)! {
            txEmail.addError()
            flag = false
        }
        
        if (txPassword.text?.isEmpty)! {
            txPassword.addError()
            flag = false
        }
        
        return flag
    }
    
    func segueToMainStoryboard(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(viewController, animated: true, completion: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 1 && row == 0{
            
            makeSignUp()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension SignUpTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.removeError()
        
        return true
    }
}
