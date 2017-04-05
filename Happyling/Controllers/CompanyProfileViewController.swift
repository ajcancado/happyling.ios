//
//  CompanyProfileViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CompanyProfileViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mLabelName: UILabel!
    
    @IBOutlet weak var mLabelReplyTime: UILabel!
    
    @IBOutlet weak var mLabelWebsite: UILabel!
    
    @IBOutlet weak var mLabelAddress: UILabel!
    
    var company: Company!
    
    var issueStatus = 3
    
    var companyIssues: [Issue] = []
    
    let topMessage = "Eba..."
    let bottomMessage = "Nenhum problema"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = company.name
        
        setupCompanyInfo()
        
        setupTableView()
        
        getIssuesReport()
    }
    
    func setupCompanyInfo(){
        
        mLabelName.text = company.name
        mLabelReplyTime.text = company.status
        mLabelWebsite.text = company.webSite
        mLabelAddress.text = "\(company.city) / \(company.country)"
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
        
    }
    
    func getIssuesReport(){
        
        showHUD()
        
        var params : [String: Any] = [:]
    
        params["companyId"] = company.id
        params["statusId"] = issueStatus
        
        Alamofire.request(IssueRouter.GetIssueReport(params)).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let getIssueResponse = Mapper<GetIssuesResponse>().map(JSON: json as! [String: Any])
                
                if getIssueResponse?.data != nil {
                    
                    self.companyIssues = (getIssueResponse?.data)!
                    
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
                else if getIssueResponse?.responseAttrs.errorMessage != nil {
                    
                    print(getIssueResponse?.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }

        
        
    }
    
    @IBAction func changeSegmentedControl(_ segment: UISegmentedControl) {
        
        if segment.selectedSegmentIndex == 0 {
            issueStatus = 3
        }
        else if segment.selectedSegmentIndex == 1 {
            issueStatus = 4
        }
        else if segment.selectedSegmentIndex == 2 {
            issueStatus = 5
        }
        else if segment.selectedSegmentIndex == 3 {
            issueStatus = 6
        }
        
        getIssuesReport()
        
    }

    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    }

}

extension CompanyProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.companyIssues.count == 0 {
            
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
            
        } else {
            
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true
        }
        
        return companyIssues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        
        let issue = companyIssues[row]
        
        cell.textLabel?.text = issue.descricao
        
        return cell
        
    }
    
    
}

extension CompanyProfileViewController: UITableViewDelegate {
    
    
    
    
}
