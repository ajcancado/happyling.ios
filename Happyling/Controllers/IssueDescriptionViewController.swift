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

class IssueDescriptionViewController: GenericViewController {

    var issue: Issue!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        let send = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(makeInteraction))
        
        navigationItem.rightBarButtonItem = send

    }

    func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
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

extension IssueDescriptionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return issue.interactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let issueInteraction = issue.interactions[row]
        
        cell.textLabel?.text = issueInteraction.owner
        cell.detailTextLabel?.text = issueInteraction.descricao
        
        if row % 2 == 0 {
            cell.backgroundColor = UIColor.groupTableViewBackground
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
}

extension IssueDescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
