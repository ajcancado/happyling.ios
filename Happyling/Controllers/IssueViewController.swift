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

protocol SelectComplaintTypeProtocol{
    
    func selectedComplaintType(company: IssueType)
}

class IssueViewController: GenericTableViewController, SelectCompanyProtocol, SelectComplaintTypeProtocol,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var companyName: UILabel!

    @IBOutlet weak var issueType: UILabel!
    
    @IBOutlet weak var complaintSubject: UITextField!
    
    @IBOutlet weak var complaintDescription: UITextField!
    
    @IBOutlet weak var imageAttachment: UIImageView!
    
    let imagePicker = UIImagePickerController()

    var companySelected : Company!
    var issueTypeSelected: IssueType!
    
    let topMessage = "Ops.."
    let bottomMessage = "Você precisa se cadastrar para poder criar uma reclamação"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "New Complaint"
        
        setupNavigationBarButtomItems()
        
        setupTableView()
    
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    
    func setupNavigationBarButtomItems(){
        
        let send = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(makeIssueReport))
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if userId != Constants.SessionKeys.guestUserId {
        
            navigationItem.rightBarButtonItem = send
        }
    }

    func setupTableView(){
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
    
    }
    
    
    func selectedCompany(company: Company){
        
        companySelected = company
        
        companyName.text = company.name
        
        tableView.reloadData()
    }
    
    func selectedComplaintType(company: IssueType) {
        
        issueTypeSelected = company
        
        issueType.text = company.name
        
        tableView.reloadData()
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
    
    func clearInputs(){
        
        companyName.text = ""
        companySelected = nil
        
        issueType.text = ""
        issueTypeSelected = nil
        
        complaintSubject.text = ""
        complaintDescription.text = ""
        
        tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = indexPath.section
        
        if section == 0 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerID") as!SearchViewController
            
            viewController.delegate = self
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if section == 1 {
            
            performSegue(withIdentifier: "segueToComplaintType", sender: self)
        }
        else if section == 4 {
            
            clearInputs()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        var flag = true
        
        if companySelected == nil{
            flag = false
        }
        
        if issueTypeSelected == nil{
            flag = false
        }
        
        if (complaintSubject.text?.isEmpty)! {
            
            complaintSubject.addError()
            flag = false
        }
        
        if (complaintDescription.text?.isEmpty)! {
            
            complaintDescription.addError()
            flag = false
        }
        
        return flag
    }
    
    
    func makeIssueReport(){
        
        if validate() {
            
            let issueReportDTO = IssueReportDTO()
            
            issueReportDTO.user = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
            issueReportDTO.company = companySelected.id
            issueReportDTO.type = issueTypeSelected.id
            issueReportDTO.subject = complaintSubject.text
            issueReportDTO.descricao = complaintDescription.text
    
            let currentInteraction = CurrentInteraction()
    
            var attachments: [Attachment] = []
            
//            let attachment = Attachment()
            
//            attachment.name = "teste.jpg"
//            attachment.encodingData = imageAttachment.image?.encodeToBase64String()
            
//            attachments.append(attachment)
            
            currentInteraction.attachments = attachments
            
            issueReportDTO.currentInteraction = currentInteraction
            
            self.showHUD()
            
            print(issueReportDTO.toJSON())

            Alamofire.request(IssueRouter.MakeIssueReport(issueReportDTO.toJSON())).responseJSON { response in
            
                self.hideHUD()
                
                switch response.result {
                    
                case .success(let json):
                    
                    print("Sucesso !!! \(json)")
                    
                    let signInResponse = Mapper<SignInResponse>().map(JSON: json as! [String: Any])
                    
                    if signInResponse?.data != nil {
                        
                        self.clearInputs()
                        
                        let alertController = UIAlertController(title: "Happyling", message: "Congratulations!", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToComplaintType" {
         
            let svc = segue.destination as! ComplaintTypeViewController
            
            svc.delegate = self
            
        }
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    
//        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
//        
//        if userId != Constants.SessionKeys.guestUserId {
//            
//            tableView.separatorStyle = .singleLine
//            
//            tableView.backgroundView?.isHidden = true
//            
//            if section == 0 {
//                return 1
//            }
//            else{
//                return 6
//            }
//        }
//        else{
//            
//            tableView.separatorStyle = .none
//            
//            tableView.backgroundView?.isHidden = false
//            
//            return 0
//        }
//    }
}

extension IssueViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.removeError()
        
        return true
    }
}
