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

class AccountViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userId: Int!
    var isFromFacebook: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        isFromFacebook = SessionManager.getBoolForKey(key: Constants.SessionKeys.isFromFacebook)

        tableView.dataSource = self
        tableView.delegate = self
        
        setupTableView()
    }

    func setupTableView(){
        
        self.tableView.backgroundColor = Constants.Colors.gray
        
        self.tableView.tableFooterView = UIView(frame: .zero)
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
    
    func alertToSignUp(){
        
        let alertController = UIAlertController(title: "Happyling", message: "Querido usuário, faça seu cadastro para poder acessar os dados.", preferredStyle: .alert)
        
        let makeSignUpAction = UIAlertAction(title: "Ok, fazer agora", style: .default, handler: {
            alert -> Void in
            
            SessionManager.removeObjectForKey(key: Constants.SessionKeys.userId)
            
            self.segueToSignInStoryboard()
            
        })
        
        let cancelAction = UIAlertAction(title: "Depois", style: .cancel, handler: nil)
        
        alertController.addAction(makeSignUpAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToIssues" {
            
            let svc = segue.destination as! ProblemsViewController
            
            let section = tableView.indexPathForSelectedRow?.section
            
            if section == 1 {
                
                svc.status = Status(id: 1, name: "In Analysis")
            }
            else if section == 2 {
                svc.status = Status(id: 3, name: "Resolved")
            }
            else if section == 3{
                svc.status = Status(id: 4, name: "Unresolved")
            }
        }
    }

}

extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 && row == 1 {
            
            if isFromFacebook || userId == Constants.SessionKeys.guestUserId{
                
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
                
                cell.imageView?.image = UIImage(named: "ic_settings")
                cell.textLabel?.text = "My Account"
            }
            else if row == 1{
                cell.textLabel?.text = "Change Password"
            }
            else{
                
                cell.textLabel?.text = "Notifications"
            }
        }
        else if section == 1{
            
            cell.imageView?.image = UIImage(named: "ic_question")
            cell.textLabel?.text = "Problems Opened"
        }
        else if section == 2 {
            
            cell.textLabel?.text = "Problems Solved"
            cell.imageView?.image = UIImage(named: "ic_happy")
            
        }
        else if section == 3 {
            
            cell.textLabel?.text = "Problems not Solved"
            cell.imageView?.image = UIImage(named: "ic_sad")
            
        }
        else if section == 4 {
            
            cell.imageView?.image = UIImage(named: "ic_rating_this_app")
            cell.textLabel?.text = "Rating App"
        }
        else if section == 5{
            
            cell.imageView?.image = UIImage(named: "ic_termsconditions")
            cell.textLabel?.text = "Terms of Use"
        }
        else if section == 6 {
            
            cell.imageView?.image = UIImage(named: "ic_termsconditions")
            cell.textLabel?.text = "Happyling for Business"
        }
        else {
            
           cell.textLabel?.text = "Sign out"
        }
        

        return cell
    }
    
}

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            
            if row == 0  {
                
                if userId != Constants.SessionKeys.guestUserId {
                    
                    performSegue(withIdentifier: "segueToProfile", sender: self)
                }
                else{
                    
                    alertToSignUp()
                }

            }
            else if row == 1{
                self.changeUserPassword()
            }
        }
        else if section == 1 || section == 2 || section == 3  {
            
            if userId != Constants.SessionKeys.guestUserId {
                
                performSegue(withIdentifier: "segueToIssues", sender: self)
            }
            else{
                
                alertToSignUp()
            }
        }
        else if section == 4{
            
//            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/1225068773")!)
        }
        else if section == 5{
            
        }
        else if section == 6{
            
            if userId != Constants.SessionKeys.guestUserId {
                
                performSegue(withIdentifier: "segueToCompanyInfo", sender: self)
            }
            else{
            
                alertToSignUp()
            }
            
        }
        else if section == 7 {
            
            SessionManager.removeObjectForKey(key: Constants.SessionKeys.userId)
            
            segueToSignInStoryboard()
            
        }
    
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}
