//
//  IssueDescriptionViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 19/04/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol RefreshIssueProtocolAfterEvaluate{
    
    func refreshAfterEvaluate()
}

class ProblemDetailsViewController: GenericViewController,RefreshIssueProtocolAfterEvaluate {

    var issue: Issue!
    
    var isFromCompanyDetails: Bool!
    
    var canEvaluate = false
    
    var delegate: RefreshIssueProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    var getDescription = false
    var getCanBeEvaluate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.Colors.gray

        setupTableView()
        
        setupTableFooterView()
        
        if issue.status.id == 5 && issue.user.id == SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId) {
        
            let send = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(makeInteraction))
            
            navigationItem.rightBarButtonItem = send
            
        }
        
        showHUD()
        
        startServiceCalls()
    }

    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProblemCellID")
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupTableFooterView(){
        
        if canEvaluate && issue.user.id == SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId) {
        
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            customView.backgroundColor = Constants.Colors.orange
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.setTitle("Evaluate", for: .normal)
            button.titleLabel?.textAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(makeEvaluate), for: .touchUpInside)
            customView.addSubview(button)
            
            customView.layer.cornerRadius = 10
            customView.clipsToBounds = true
            
            tableView.tableFooterView = customView
            
        }
        
    }
    
    func startServiceCalls(){
        
        getIssueDescription()
        
        validateIssueCanBeEvaluated()
        
    }
    
    func getIssueDescription(){
        
        Alamofire.request(IssueRouter.GetIssueDescription(issue.id)).responseJSON { response in
            
            switch response.result {
                
            case .success(let json):
                
                let getIssueDescriptionResponse = Mapper<GetIssueDescriptionResponse>().map(JSON: json as! [String: Any])
                
                if getIssueDescriptionResponse?.data != nil {
                    
                    self.issue = getIssueDescriptionResponse?.data
                    
                    self.getDescription = true
                    
                    self.validateServiceResponse()
                }
                
                
            case .failure(let error):
                
                
                print(error.localizedDescription)
            }
        }
    }
    
    func validateIssueCanBeEvaluated(){
        
        Alamofire.request(IssueRouter.CanBeEvaluated(issue.id)).responseJSON { response in
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let canEvaluateResponse = Mapper<CanEvaluateResponse>().map(JSON: json as! [String: Any])
                
                if canEvaluateResponse?.data != nil {
                    
                    self.getCanBeEvaluate = true
                    
                    self.canEvaluate = canEvaluateResponse!.data
                    
                    self.validateServiceResponse()
                }
                
            case .failure(let error):
                
                
                print(error.localizedDescription)
            }
        }

    }
    
    func validateServiceResponse(){
        
        if  getDescription && getCanBeEvaluate {
            
            if delegate != nil {
                
                self.delegate.refreshIssue(issue: self.issue)
            }
            
            self.tableView.reloadData()
            
            self.setupTableFooterView()
            
            hideHUD()
        }
    }
    
    func makeEvaluate(){
        
        let svc = RatingViewController()
        svc.modalTransitionStyle = .coverVertical
        
        svc.issue = issue
        svc.delegate = self
        
        present(svc, animated: true, completion: nil)
        
    }
    
    func refreshAfterEvaluate(){
        
        showHUD()
        
        startServiceCalls()
    }
    
    func makeInteraction(){
        
        
        let alertController = UIAlertController(title: "Make Interaction", message: "", preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "Send", style: .default, handler: {
            alert -> Void in
            
            self.showHUD()
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            var params: [String: Any] = [:]
            
            params["description"] = firstTextField.text
            params["issueReport"] = self.issue.id
            
            Alamofire.request(IssueRouter.MakeIssueInteraction(params)).responseJSON { response in
                
                switch response.result {
                    
                case .success( _):
                    
                    self.startServiceCalls()
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your interaction"
        }
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}

// MARK: - UITableViewDataSource

extension ProblemDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return issue.interactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCellID", for: indexPath) as! ProblemsTableViewCell
            
            cell.companyLogo.image = issue.company.validateAverageImage()
            
            cell.companyName.text = issue.company.name
            
            let date = issue.creationDate.toDate()
            
            let format = NSLocalizedString("DATE_FORMAT", comment: "")
            
            cell.problemDate.text = DateHelper.formatDate(date: date, withFormat: format)
            
            cell.problemSubject.text = issue.subject
            cell.problemStatus.text = issue.status.name
            
            cell.selectionStyle = .none
            
            cell.contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            cell.contentView.layer.borderWidth = 1.0
            
            return cell
        }
        else{
            
            let issueInteraction = issue.interactions[row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
            
            if issueInteraction.owner == "USER" {
            
                cell.imageView?.image = UIImage(named: "ic_long_arrow_right")
            }
            else{
                cell.imageView?.image = UIImage(named: "ic_long_arrow_left")
            }
            
            cell.textLabel?.text = issueInteraction.descricao
            
            cell.selectionStyle = .none
            
            cell.contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            cell.contentView.layer.borderWidth = 1.0
            
            return cell
        
        }
    }
}

// MARK: - UITableViewDelegate

extension ProblemDetailsViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let section = indexPath.section
//        
//        if section == 0 {
//            return 120
//        }
//        
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
