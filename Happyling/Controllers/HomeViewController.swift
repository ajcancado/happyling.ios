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
import EAIntroView

class HomeViewController: GenericViewController {

    @IBOutlet weak var introView: EAIntroView!
    
    var eaIntroView: EAIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        setupIntroView()
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(moverParaProximoSlide), userInfo: nil, repeats: true)
    }
    
    func setupIntroView(){
        
        let page1 = EAIntroPage()
        
        page1.title = "Hello world"
        page1.titleColor = UIColor.gray
        page1.desc = "Sample description 1"
        page1.descColor = UIColor.gray
        
        let page2 = EAIntroPage()
        
        page2.title = "Hello world 2"
        page2.titleColor = UIColor.gray
        page2.desc = "Sample description 2"
        page2.descColor = UIColor.gray
        
        eaIntroView = EAIntroView(frame: introView.bounds, andPages: [page1,page2])
        
        eaIntroView.skipButton = .none
        eaIntroView.pageControl.pageIndicatorTintColor = UIColor.gray
        eaIntroView.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        
        eaIntroView.show(in: introView, animateDuration: 0.3)
        
    }

    func moverParaProximoSlide() {
        
        let nextSlide = eaIntroView.currentPageIndex + 1
        
        if Int(nextSlide) >= eaIntroView.pages.count {
            
            eaIntroView.scrollToPage(for: 0, animated: true)
        }
        else {
            
            eaIntroView.scrollToPage(for: nextSlide , animated: true)
        }
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
        
        
        SessionManager.setInteger(int: Constants.SessionKeys.guestUserId, forKey: Constants.SessionKeys.userId)
        
        SessionManager.setBool(bool: false, forKey: Constants.SessionKeys.isFromFacebook)
        
        segueToMainStoryboard()
        
    }
    
    func makeLoginWithFacebook(){
        
        if (FBSDKAccessToken.current() != nil) {
            
            self.getInfoFromFacebook()
            
        }
        else{
            
            let login = FBSDKLoginManager()
            
            login.loginBehavior = FBSDKLoginBehavior.native
            
            login.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { result, error in
            
                if let e = error{
                    
                    print("Process \(e.localizedDescription)")
                }
                else if let r = result  {
                    
                    if r.isCancelled {
                        
                        print("Cancelled")
                    }
                    else{
                         self.getInfoFromFacebook()
                    }
                }
            })
        }
    }

    func getInfoFromFacebook(){
        
        showHUD()
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture"]).start(completionHandler: { connection, result, error in
            
                if (error == nil){
                    
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
                    
                    print(signInResponse!.responseAttrs.errorMessage!)
                    
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
        
        if SessionManager.containsObjectForKey(key: Constants.SessionKeys.deviceToken) {
            params["deviceToken"] = SessionManager.getObjectForKey(key: Constants.SessionKeys.deviceToken)
        }
        
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

