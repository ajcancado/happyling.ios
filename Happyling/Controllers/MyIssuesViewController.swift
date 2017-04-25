//
//  MyIssuesViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class MyIssuesViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var issues: [Issue] = []
    var status: [Status] = []
    
    var issuesFromUser = false
    var issuesStatus = false
    
//    let image = UIImage(named: "ic_empty_search_radar")!
    let topMessage = "Eba..."
    let bottomMessage = "Nenhum problema"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarButtom()
        
        setupTableView()
        
        startServiceCalls()
    }

    
    func setupNavigationBarButtom(){
        
        let buttonFilter = UIButton()
        buttonFilter.setImage(UIImage(named: "ic_filter_issues"), for: .normal)
        buttonFilter.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(25))
        buttonFilter.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: buttonFilter)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
        
    }
    
    func showFilters(){
        
        let alertController = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        
        for s in status  {
           
            let someStatus = UIAlertAction(title: s.name, style: .default) { (action:UIAlertAction!) in
                
                self.showHUD()
                
                self.getIssuesFromUserAnd(status: s)
            }
            
            alertController.addAction(someStatus)
        }
        
    
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        if let presenter = alertController.popoverPresentationController {
//            presenter.sourceView = self.viewNewEvent
//            presenter.sourceRect = self.viewNewEvent.bounds
        }
        else{
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func startServiceCalls(){
        
        showHUD()
        
        getIssuesStatus()
        
        getIssuesFromUserAnd(status: nil)
        
    }
    
    func getIssuesStatus(){
        
        Alamofire.request(IssueRouter.GetIssueStatus).responseJSON { response in
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let issuesStatusResponse  = Mapper<GetIssueStatusResponse>().map(JSON: json as! [String : Any])
                
                if issuesStatusResponse?.data != nil {
                    
                    self.status = (issuesStatusResponse?.data)!
                    
                    self.issuesStatus = true
                    
                    self.handleServiceCallCompletation()
                    
                }
                else if issuesStatusResponse?.responseAttrs.errorMessage != nil {
                    
                    self.hideHUD()
                    
                    print(issuesStatusResponse!.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                self.hideHUD()
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getIssuesFromUserAnd(status: Status?) {
        
        var params: [String: Any] = [:]
        
        params["userId"] = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        if let statusReal = status {
            
            params["statusId"] = statusReal.id
            
        }
        
        Alamofire.request(IssueRouter.GetIssues(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let issuesResponse  = Mapper<GetIssuesResponse>().map(JSON: json as! [String : Any])
                
                if issuesResponse?.data != nil {
                    
                    self.issues = (issuesResponse?.data)!
                    
                    self.issuesFromUser = true
                    
                    self.handleServiceCallCompletation()
                    
                }
                else if issuesResponse?.responseAttrs.errorMessage != nil {
                    
                    self.hideHUD()
                    
                    print(issuesResponse?.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                self.hideHUD()
                
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    func handleServiceCallCompletation(){
        
        if issuesStatus && issuesFromUser{
            
            hideHUD()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            self.tableView.reloadData()
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToIssueDescription" {
            
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let issue = issues[row]
            
            let svc = segue.destination as! IssueDescriptionViewController
            
            svc.issue = issue
        }
        
    }
    
}

extension MyIssuesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.issues.count == 0 {
            
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
            
        } else {
            
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true
        }
        
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCellID", for: indexPath)
        
        let issue = issues[row]
        
        cell.textLabel?.text = issue.descricao
        cell.detailTextLabel?.text = issue.status.name
        
        return cell
        
    }
}

extension MyIssuesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueToIssueDescription", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
