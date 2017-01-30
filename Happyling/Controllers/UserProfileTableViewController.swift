//
//  UserProfileTableViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class UserProfileTableViewController: UITableViewController {
    
    var userID: Int!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateWidthsForLabels(labels: labels)
        
        setupTableView()
        setupTextFields()
        
        getUser()
    }
    
    func setupTableView(){
        
        tableView.keyboardDismissMode = .onDrag
        
        
        
    }
    
    func setupTextFields(){
        
        
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.width, height: 240))
        
        let inputView = UIView(frame: rect)
        
        let rectPicker = CGRect(origin: CGPoint(x: 0,y :40), size: CGSize(width: 0, height: 0))
        
        let datePickerView  : UIDatePicker = UIDatePicker(frame: rectPicker)
        datePickerView.datePickerMode = .date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let rectButton = CGRect(origin: CGPoint(x: (self.view.frame.size.width/2) - (100/2),y :0), size: CGSize(width: 100, height: 50))
        
        let doneButton = UIButton(frame: rectButton)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitle("Done", for: .highlighted)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.setTitleColor(UIColor.gray, for: .highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: .touchUpInside) // set button click event
        
        txDateOfBirth.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        handleDatePicker(sender: datePickerView) // Set the date on start.
        
        
        txEmail.isUserInteractionEnabled = false
        
        let pickerView = UIPickerView()
        
        pickerView.tag = 1
        pickerView.dataSource = self
        pickerView.delegate = self
        
        txGender.inputView = pickerView
        

    }
   
    func getUser(){
        
        
        if let id = SessionManager.getObjectForKey(key: Constants.SessionKeys.userId) as? Int{
            
            userID = id
        
            Alamofire.request(UserRouter.GetUser(userID: id)).responseJSON { response in
                
                switch response.result {
                    
                case .success(let json):
                    
                    print(json)
                    
                    let getUserResponse = Mapper<GetUserResponse>().map(JSON: json as! [String: Any])
                    
                    if getUserResponse?.data != nil {
                        
                        self.txName.text = getUserResponse?.data.name
                        self.txSurname.text = getUserResponse?.data.surname
                        self.txEmail.text = getUserResponse?.data.email
                        self.txDateOfBirth.text = getUserResponse?.data.dateOfBirth
                        self.txPhoneNumber.text = getUserResponse?.data.phoneNumber
                        self.txMobileNumber.text = getUserResponse?.data.mobileNumber
                        self.txGender.text = getUserResponse?.data.gender
                        self.txIdentificationNumber.text = getUserResponse?.data.identificationNumber
                        self.txPostalCode.text = getUserResponse?.data.postalCode
                        self.txCity.text = getUserResponse?.data.city
                        self.txState.text = getUserResponse?.data.state
                        self.txCountry.text = getUserResponse?.data.country

    
                    }
                    else if getUserResponse?.responseAttrs.errorMessage != nil {
                        
                        print(getUserResponse?.responseAttrs.errorMessage!)
                        
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }

                
            }
        }
        
    }
    

    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txDateOfBirth.text = dateFormatter.string(from: sender.date)
    }

    func doneButton(sender:UIButton)
    {
        txDateOfBirth.resignFirstResponder() // To resign the inputView on clicking done.
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
        
        if (txName.text?.isEmpty)! {
            return false
        }
        
        if (txEmail.text?.isEmpty)! {
            return false
        }
        
        
        return true
        
    }
    
    @IBAction func updateUser(_ sender: Any) {
    
        if validate() {
            
            var params: [String: Any] = [:]
            
            params["id"] = userID
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
            
            Alamofire.request(UserRouter.UpdateUser(params)).responseJSON { response in
                
                switch response.result {
                    
                    case .success(let json):
                        
                        print("JSON: \(json)")


                    case .failure(let error):
                        
                        print(error.localizedDescription)
                }
                
            }
            
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = c
//        
//        return
//        
//    }

}

// MARK: - UIPickerViewDataSource

extension UserProfileTableViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}

extension UserProfileTableViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            
            return "Masculino"
            
        }
        else {
            
            return "Feminino"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            
            txGender.text = "Masculino"
        }
        else{
            txGender.text = "Feminino"
        }
        
        
    }
    
    
}
