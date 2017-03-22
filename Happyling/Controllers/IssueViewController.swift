//
//  IssueViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 10/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol SelectCompanyProtocol{
    
    func selectedCompany(company: Company)
}

class IssueViewController: GenericTableViewController, SelectCompanyProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var cells: [UITableViewCell]!

    @IBOutlet weak var comanySelected: UILabel!
    
    @IBOutlet weak var txIssueType: UITextField!
    
    @IBOutlet weak var txDescription: UITextField!
    
    @IBOutlet weak var imageAttachment: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var issueTypes: [IssueType] = []
    
    var companySelected : Company!
    var issueTypeSelected: IssueType!
    
    let topMessage = "Ops.."
    let bottomMessage = "Você precisa se cadastrar para poder criar uma reclamação"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Issue"
        
        setupNavigationBarButtomItems()
        
        setupTableView()
        
        txIssueType.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        getIssueTypes()
    }
    
    
    func setupNavigationBarButtomItems(){
        
        let send = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(makeIssueReport))
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if userId != Constants.SessionKeys.guestUserId {
        
            navigationItem.rightBarButtonItem = send
        }
    }

    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
    
    }
    
    func getIssueTypes(){
        
        self.showHUD()
        
        Alamofire.request(IssueRouter.GetIssueTypes).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let issueTypeResponse = Mapper<IssueReportTypeResponse>().map(JSON: json as! [String: Any])
                
                if issueTypeResponse?.data != nil {
                    
                    self.issueTypes = (issueTypeResponse?.data)!
                    
                    self.setupPickerViewTypes()
                    
                }
                else if issueTypeResponse?.responseAttrs.errorMessage != nil {
                    
                    print(issueTypeResponse?.responseAttrs.errorMessage!)
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }
    }
    
    func setupPickerViewTypes(){
        
        let pickerView = UIPickerView()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        txIssueType.inputView = pickerView
    }
    
    func selectedCompany(company: Company){
        
        companySelected = company
        
        comanySelected.text = company.name
    }
    
    
    @IBAction func selectAttachment(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select Picture", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                alert -> Void in
                
                self.imagePicker.sourceType = .camera
                
                self.present(self.imagePicker, animated: true, completion: nil)

            })
            
            alertController.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {
            alert -> Void in
            
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerID") as!SearchViewController
            
            viewController.delegate = self
            
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageAttachment.contentMode = .scaleAspectFit
            imageAttachment.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func validate() -> Bool{
        
        if companySelected == nil{
            return false
        }
        
        if issueTypeSelected == nil{
            return false
        }
        
        if (txDescription.text?.isEmpty)! {
            return false
        }
        
        return true
    }
    
    
    func makeIssueReport(){
        
        if validate() {
            
            let issueReportDTO = IssueReportDTO()
            
            issueReportDTO.user = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
            issueReportDTO.company = companySelected.id
            issueReportDTO.type = issueTypeSelected.id
            issueReportDTO.descricao = txDescription.text
    
            let currentInteraction = CurrentInteraction()
    
            var attachments: [Attachment] = []
            
            let attachment = Attachment()
            
            attachment.name = "teste.jpg"
            attachment.encodingData = imageAttachment.image?.encodeToBase64String()
            
            attachments.append(attachment)
            
            currentInteraction.attachments = attachments
            
            issueReportDTO.currentInteraction = currentInteraction
            
            self.showHUD()

            Alamofire.request(IssueRouter.MakeIssueReport(issueReportDTO.toJSON())).responseJSON { response in
            
                self.hideHUD()
                
                switch response.result {
                    
                case .success(let json):
                    
                    print("Sucesso !!! \(json)")
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if userId != Constants.SessionKeys.guestUserId {
            
            tableView.separatorStyle = .singleLine
            
            tableView.backgroundView?.isHidden = true
            
            return 7
        }
        else{
            
            tableView.separatorStyle = .none
            
            tableView.backgroundView?.isHidden = false
            
            return 0
        }
    }
}

extension IssueViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txIssueType {
            
            issueTypeSelected = issueTypes[0]
            
            textField.text = issueTypes[0].name
            
        }
        
    }
    
}

extension IssueViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return issueTypes.count
        
    }

}

extension IssueViewController: UIPickerViewDelegate {
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return issueTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        issueTypeSelected = issueTypes[row]
        
        txIssueType.text = issueTypes[row].name
    }
    
}
