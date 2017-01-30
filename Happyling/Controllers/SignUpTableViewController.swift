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
        
        updateWidthsForLabels(labels: labels)
        
        setupTableView()
    }
    
    func setupTableView(){
        
    
        
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
    
    @IBAction func makeSignUp(_ sender: Any) {
        
        if validate() {
            
            var params: [String: Any] = [:]
            
            params["name"] = txName.text
            params["email"] = txEmail.text
            params["password"] = txPassword.text
            params["confirmPassword"]  = txPassword.text
            
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
        
        if (txName.text?.isEmpty)! {
            return false
        }
        
        if (txEmail.text?.isEmpty)! {
            return false
        }
        
        if (txPassword.text?.isEmpty)! {
            return false
        }
        
        return true
        
    }
    
    func segueToMainStoryboard(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InitialController") as UIViewController
        
        self.present(viewController, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: - Navigation

    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        return UITableViewCell()
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
