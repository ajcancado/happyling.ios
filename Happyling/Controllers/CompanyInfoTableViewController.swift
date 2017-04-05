//
//  CompanyInfoTableViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 30/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CompanyInfoTableViewController: GenericTableViewController {
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var txName: UITextField!
    @IBOutlet var txIdentificationNumber: UITextField!
    @IBOutlet var txEmail: UITextField!
    @IBOutlet var txEmailNotifications: UITextField!
    @IBOutlet var txWebSite: UITextField!
    @IBOutlet var txPostalCode: UITextField!
    @IBOutlet var txCity: UITextField!
    @IBOutlet var txState: UITextField!
    @IBOutlet var txCountry: UITextField!
    @IBOutlet var txPhoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWidthsForLabels(labels: labels)
        
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        
        return 168.0//reduce(map(labels, calculateLabelWidth), 0, max)
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
    
    func saveCompany(){
        
        if validate() {
            
            showHUD()
            
            var params: [String: Any] = [:]
            
            params["name"] = txName.text
            params["identificationNumber"] = txIdentificationNumber.text
            
            if let id = SessionManager.getObjectForKey(key: Constants.SessionKeys.userId) as? Int{
                params["businessPerson"] = id 
            }
            
            params["email"]  = txEmail.text
            params["emailNotifications"]  = txEmailNotifications.text
            params["webSite"]  = txWebSite.text
            params["postalCode"]  = txPostalCode.text
            params["city"]  = txCity.text
            params["state"]  = txState.text
            params["country"]  = txCountry.text
            params["phoneNumber"]  = txPhoneNumber.text
    
            print(params)
            
            
            Alamofire.request(CompanyRouter.MakeCompany(params)).responseJSON { response in
                
                switch response.result {
                    
                case .success(let json):
                    
                    print(json)
                    
                    self.hideHUD()
                    
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
                    
                    self.hideHUD()
                    
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let section = indexPath.section
        
        if section == 1 {
            saveCompany()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
