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

class ProblemsViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var issues: [Issue] = []

    var statusIds: [Int] = []
    
    var problemType: String!
    
//    let image = UIImage(named: "ic_empty_search_radar")!
    let topMessage = "Eba..."
    let bottomMessage = "Nenhum problema"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Constants.Colors.gray
        
        navigationItem.title = problemType
    
        setupTableView()
        
        startServiceCalls()
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.register(UINib(nibName: "ProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
    }
    
    func startServiceCalls(){
        
        showHUD()
        
        getIssuesFromUserAndStatus()
    }
    
    func getIssuesFromUserAndStatus() {
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        var params: [String: Any] = [:]
        
        params["userId"] = userId
        
        var statusIdString: String = ""
        
        for statusId in statusIds {
            
            statusIdString = statusIdString + "\(statusId),"
        }
        
        statusIdString = statusIdString.substring(to: statusIdString.index(before: statusIdString.endIndex))
        
        params["statusId"] = statusIdString
        
        
        Alamofire.request(IssueRouter.GetIssues(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let issuesResponse  = Mapper<GetIssuesResponse>().map(JSON: json as! [String : Any])
                
                if issuesResponse?.data != nil {
                    
                    self.issues = (issuesResponse?.data)!
                    
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
                else if issuesResponse?.responseAttrs.errorMessage != nil {
                    
                    self.hideHUD()
                    
                    print(issuesResponse!.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                self.hideHUD()
                
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToIssueDescription" {
            
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let issue = issues[row]
            
            let svc = segue.destination as! ProblemDetailsViewController
            
            svc.issue = issue
        }
    }
}

// MARK: - UITableViewDataSource

extension ProblemsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        if self.issues.count == 0 {
            self.tableView.backgroundView?.isHidden = false
        }
        else {
            self.tableView.backgroundView?.isHidden = true
        }
        
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! ProblemsTableViewCell
        
        let issue = issues[section]
        
        cell.companyLogo.backgroundColor = Constants.Colors.orange
        cell.companyLogo.layer.cornerRadius = cell.companyLogo.frame.size.width / 2
        cell.companyLogo.clipsToBounds = true
        
        cell.companyName.text = issue.company.name
        
        let date = issue.creationDate.toDate()
        
        let format = NSLocalizedString("DATE_FORMAT", comment: "")
        
        cell.problemDate.text = DateHelper.formatDate(date: date, withFormat: format)
        
        cell.problemSubject.text = issue.subject
        cell.problemStatus.text = issue.status.name
        
        cell.contentView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cell.contentView.layer.borderWidth = 1.0
        
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProblemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        let issue = issues[section]
        
        if issue.status.id != 1  {
            performSegue(withIdentifier: "segueToIssueDescription", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
