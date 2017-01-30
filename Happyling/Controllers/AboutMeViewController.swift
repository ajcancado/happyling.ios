//
//  AboutMeViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 27/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class AboutMeViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Me"

        tableView.dataSource = self
        tableView.delegate = self
        
        setupTableView()
    }

    func setupTableView(){
        
        self.tableView.backgroundColor = Constants.Colors.gray
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if segue.identifier == "segueToProfile" {
            
            
            
            
        }
    }
 
    func segueToSignInStoryboard(){
        
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func changeUserPassword(){
        
        let alertController = UIAlertController(title: "Change Password", message: "", preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "Change", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            let thirdTextField = alertController.textFields![2] as UITextField
            
            var params: [String: Any] = [:]
            
            if let id = SessionManager.getObjectForKey(key: Constants.SessionKeys.userId) as? Int{
                params["id"] = id
            }
            params["oldPass"] = firstTextField.text
            params["newPass"] = secondTextField.text
            params["confirmNewPass"] = thirdTextField.text
            
            self.changePass(params: params)
        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter current password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new password again"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    func changePass(params: [String:Any]) {
        
        self.showHUD()
        
        Alamofire.request(UserRouter.UpdatePass(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                
                if signInResponse?.data != nil {
                    
                    SessionManager.setInteger(int: (signInResponse?.data)!, forKey: Constants.SessionKeys.userId)
                    
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

extension AboutMeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "About me"
        }
        else if section == 1 {
            return "My problems"
        }
        else if section == 2{
            return "About Happyling"
        }
        else {
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 && row == 1 {
            
            let isFromFacebook = SessionManager.getBoolForKey(key: Constants.SessionKeys.isFromFacebook)
            
            if isFromFacebook {
                
                return 0
                
            }
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
       
        if section == 0{
            
            if row == 0 {
                
                cell.imageView?.image = UIImage(named: "ic_user_profile")
                cell.textLabel?.text = "My Profile"
            }
            else{
                cell.textLabel?.text = "Change Password"
            }
        }
        else if section == 1{
            
            if row == 0 {
                
                cell.textLabel?.text = "Opened"
            }
            else if row == 1{
                cell.textLabel?.text = "Solved"
            }
            else{
                cell.textLabel?.text = "Not Solved"
            }
        }
        else if section == 2 {
            
            if row == 0 {
                cell.imageView?.image = UIImage(named: "ic_rating_this_app")
                cell.textLabel?.text = "Rating App"
            }
            else if row == 1{
                
                cell.imageView?.image = UIImage(named: "ic_termsconditions")
                cell.textLabel?.text = "Terms of Use"
            }
            else{
                cell.textLabel?.text = "Happyling for Business"
            }
            
        }
        else {
            
           cell.textLabel?.text = "Sign out"
        }
        

        return cell
    }
    
}

extension AboutMeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            
            if row == 0 {
                performSegue(withIdentifier: "segueToProfile", sender: self)
            }
            else if row == 1{
                self.changeUserPassword()
            }
        }
        else if section == 1 {
            performSegue(withIdentifier: "segueToIssues", sender: self)
        }
        else if section == 2{
            
            if row == 2 {
                performSegue(withIdentifier: "segueToCompanyInfo", sender: self)
            }
            
        }
        else if section == 3 {
            
            SessionManager.removeObjectForKey(key: Constants.SessionKeys.userId)
            
            segueToSignInStoryboard()
            
        }
    
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
