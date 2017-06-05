//
//  CreateSimpleCompanyViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 05/06/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CreateSimpleCompanyViewController: GenericTableViewController {

    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var txName: UITextField!
    @IBOutlet var txEmail: UITextField!
    @IBOutlet var txWebsite: UITextField!
    
    var delegate: CreateCompanyProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create Simple Company"
        
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
        
        
        return 66//reduce(map(labels, calculateLabelWidth), 0, max)
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
        
        var flag = true
        
        if (txName.text?.isEmpty)! {
            txName.addError()
            flag = false
        }
        
        if (txEmail.text?.isEmpty)! {
            txEmail.addError()
            flag = false
        }
        
        if (txWebsite.text?.isEmpty)! {
            txWebsite.addError()
            flag = false
        }
        
        return flag
    }
    
    func makeCompanySimple() {
        
        if validate() {
            
            var params: [String: Any] = [:]
            
            params["name"] = txName.text
            params["email"] = txEmail.text
            params["webSite"] = txWebsite.text
            params["status"]  = "ACTIVE"
            params["category"] = 2
         
            showHUD()
            
            Alamofire.request(CompanyRouter.MakeCompanySimple(params)).responseJSON { response in
                
                self.hideHUD()
                
                switch response.result {
                    
                case .success(let json):
                    
                    print(json)
                    
                    self.delegate.createCompany()
                    
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 1 && row == 0{
            
            makeCompanySimple()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
