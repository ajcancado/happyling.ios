//
//  ComplaintTypeViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 28/03/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ComplaintTypeViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    var complaintTypes: [IssueType] = []
    
    var delegate: SelectComplaintTypeProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getIssueTypes()
        
        tableView.tableFooterView = UIView(frame: .zero)
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
                    
                    self.complaintTypes = (issueTypeResponse?.data)!
                    
                    self.tableView.reloadData()
                    
                }
                else if issueTypeResponse?.responseAttrs.errorMessage != nil {
                    
                    print(issueTypeResponse?.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }
    }

}

extension ComplaintTypeViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return complaintTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as UITableViewCell
        
        let complaintType = complaintTypes[row]
    
        cell.textLabel?.text = complaintType.name

        
        return cell
    }
    
    
}

extension ComplaintTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if delegate != nil {
            
            let complaintType = complaintTypes[row]
            
            delegate.selectedComplaintType(company: complaintType)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
