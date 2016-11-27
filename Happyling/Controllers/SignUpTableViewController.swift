//
//  SignUpViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 26/11/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire

class SignUpTableViewController: UITableViewController{

    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var txName: UITextField!
    @IBOutlet var txSurname: UITextField!
    @IBOutlet var txEmail: UITextField!
    @IBOutlet var txDateOfBirth: UITextField!
    @IBOutlet var txPhoneNumber: UITextField!
    @IBOutlet var txMobileNumber: UITextField!
    @IBOutlet var txGender: UITextField!
    @IBOutlet var txIdentificationNumber: UITextField!
    @IBOutlet var txPostalCode: UITextField!
    @IBOutlet var txCity: UITextField!
    @IBOutlet var txState: UITextField!
    @IBOutlet var txCountry: UITextField!
    @IBOutlet var txUsername: UITextField!
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
        
    
        return 117.5//reduce(map(labels, calculateLabelWidth), 0, max)
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
    
    func validate() -> Bool {
        
        
        return true
        
    }
    
    func signUpUser() {
        
        if validate() {
            
            var params: [String: Any] = [:]

            params["name"] = txName.text
            params["surname"] = txSurname.text
            params["email"] = txEmail.text
            params["dateOfBirth"] = txDateOfBirth.text
            params["phoneNumber"] = txPhoneNumber.text
            params["mobileNumber"] = txMobileNumber.text
            params["gender"] = txGender.text
            params["identificationNumber"] = txIdentificationNumber.text
            params["postalCode"] = txPostalCode.text
            params["city"] = txCity.text
            params["state"] = txState.text
            params["country"] = txCountry.text
            params["username"] = txUsername.text
            params["password"] = txPassword.text
            
            Alamofire.request(UserRouter.CreateUser(params)).responseJSON { response in
                
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                
                
            }
            
            
            
        }
    
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
