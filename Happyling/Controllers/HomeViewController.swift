//
//  HomeViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import FBSDKLoginKit

class HomeViewController: GenericViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLoginView" {
            
            let _ = segue.destination as! LoginViewController
            
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func segueForLoginWithFacebook(_ sender: Any) {
        
        makeLoginWithFacebook()
    }
    
    @IBAction func segueForLoginWithEmail(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showLoginView", sender: self)
        
    }

    @IBAction func segueWithoutAuthentication(_ sender: Any) {
        
        segueToMainStoryboard()
        
    }
    
    func makeLoginWithFacebook(){
        
        if (FBSDKAccessToken.current() != nil) {
            
            self.getInfoFromFacebook()
            
        }
        else{
            
            let login = FBSDKLoginManager()
            
            login.loginBehavior = FBSDKLoginBehavior.web
            
            login.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { result, error in
            
                if error != nil {
                    
                    print("Process \(error?.localizedDescription)")
                }
                else if (result?.isCancelled)! {
                    
                    print("Cancelled")
                }else {
            
                    self.getInfoFromFacebook()
                }
            
            })
            
        }
        
    }



    func getInfoFromFacebook(){
        
        showHUD()
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture"]).start(completionHandler: { connection, result, error in
            
                if (error == nil){
                    
                    print(result)
                    
                    let facebookUser = Mapper<FacebookUser>().map(JSON: result as! [String: Any])
                    
                    self.tryLoginWithFacebook(facebookUser: facebookUser!)
                    
                    
                }
                else{
                
                    self.hideHUD()
                }
            
        })
        
    }
    
    func tryLoginWithFacebook( facebookUser: FacebookUser) {
        
        var params: [String: Any] = [:]
        
        params["facebookId"] = facebookUser.id
        
        Alamofire.request(SignInRouter.MakeLoginFacebook(params)).responseJSON { response in
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                
                if signInResponse?.data != nil {
                    
                    self.hideHUD()
                    
                    SessionManager.setInteger(int: (signInResponse?.data)!, forKey: Constants.SessionKeys.userId)
                    
                    SessionManager.setBool(bool: true, forKey: Constants.SessionKeys.isFromFacebook)
                    
                    self.segueToMainStoryboard()
                    
                }
                else if signInResponse?.responseAttrs.errorMessage != nil {
                    
                    print(signInResponse?.responseAttrs.errorMessage!)
                    
                    self.signUpUserFacebook(facebookUser: facebookUser)
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func signUpUserFacebook(facebookUser: FacebookUser){
        
        var params: [String: Any] = [:]
        
        params["facebookId"] = facebookUser.id
        params["name"] = facebookUser.name
        params["email"] = facebookUser.email
        
        Alamofire.request(UserRouter.CreateUserFacebook(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                
                if signInResponse?.data != nil {
                    
                    SessionManager.setInteger(int: (signInResponse?.data)!, forKey: Constants.SessionKeys.userId)
                    
                    SessionManager.setBool(bool: true, forKey: Constants.SessionKeys.isFromFacebook)
                    
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
