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

class ProblemDetailsViewController: GenericViewController {

    var issue: Issue!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Constants.Colors.gray

        setupTableView()
        
        let send = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(makeInteraction))
        
        navigationItem.rightBarButtonItem = send

    }

    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProblemCellID")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func makeInteraction(){
        
        if issue.status.id == 3 {
            
            let svc = RatingViewController()
            svc.modalTransitionStyle = .coverVertical
            
            svc.issue = issue

            present(svc, animated: true, completion: nil)
            
        }
        else{
        
            let alertController = UIAlertController(title: "Make Interaction", message: "", preferredStyle: .alert)
            
            let changeAction = UIAlertAction(title: "Send", style: .default, handler: {
                alert -> Void in
                
                self.showHUD()
                
                let firstTextField = alertController.textFields![0] as UITextField
                
                var params: [String: Any] = [:]
                
                params["description"] = firstTextField.text
                params["issueReport"] = self.issue.id
                
                Alamofire.request(IssueRouter.MakeIssueInteraction(params)).responseJSON { response in
                    
                    self.hideHUD()
                    
                    switch response.result {
                        
                    case .success(let json):
                        
                        print("Sucesso !!! \(json)")
                        
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
    
}

// MARK: - UITableViewDataSource

extension ProblemDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return issue.interactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        let issueInteraction = issue.interactions[section]
        
        if row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCellID", for: indexPath) as! ProblemsTableViewCell
            
            cell.companyLogo.backgroundColor = Constants.Colors.oranage
            cell.companyLogo.layer.cornerRadius = cell.companyLogo.frame.size.width / 2
            cell.companyLogo.clipsToBounds = true
            
            cell.companyName.text = issue.company.name
            //        cell.problemDate.text =
            
            cell.problemSubject.text = issue.subject
            cell.problemStatus.text = issue.status.name
            
            
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
            
            cell.textLabel?.text = issueInteraction.descricao
            
            return cell
        
        }
    }
}

// MARK: - UITableViewDelegate

extension ProblemDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
