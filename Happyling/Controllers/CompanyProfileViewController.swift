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

let companyCellID = "CompanyCellID"
let cellID = "CellID"
let collectionTableViewCellID = "CollectionTableViewCellID"
let problemsTableViewCellID = "ProblemsTableViewCellID"

class CompanyProfileViewController: GenericViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var problemsTableView: UITableView!
    
    var company: Company!
    
    var statusIds: [Int] = []
    
    var companyIssues: [Issue] = []
    
    var issueTypeSearch = 0
    
    let topMessage = "Happyling"
    let bottomMessage = "No problems found"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = company.name
        
        setupTableView()
        
        statusIds.append(3)
        
        getIssuesReport()
    }

    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: companyCellID)
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: collectionTableViewCellID)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Creating new tableview
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let tableViewContentSize = tableView.contentSize
        
        let diference = screenSize.height - 300//tableViewContentSize.height
        
        problemsTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: diference))
        
        problemsTableView.tag = 2
        problemsTableView.backgroundColor = Constants.Colors.gray
        
        problemsTableView.register(UINib(nibName: "ProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: problemsTableViewCellID)
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        problemsTableView.backgroundView = emptyBackgroundView
        problemsTableView.backgroundView?.isHidden = true
        
        problemsTableView.tableFooterView = UIView(frame: .zero)
        
        tableView.tableFooterView = problemsTableView
        
    }
    
    func getIssuesReport(){
        
        showHUD()
        
        var params: [String: Any] = [:]
        
        params["companyId"] = company.id
        
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
                
                let getIssueResponse = Mapper<GetIssuesResponse>().map(JSON: json as! [String: Any])
                
                if getIssueResponse?.data != nil {
                    
                    self.companyIssues = (getIssueResponse?.data)!
                    
                    self.problemsTableView.dataSource = self
                    self.problemsTableView.delegate = self
                    
                    self.problemsTableView.reloadData()
                    
                }
                else if getIssueResponse?.responseAttrs.errorMessage != nil {
                    
                    print(getIssueResponse!.responseAttrs.errorMessage!)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CompanyProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TypeCollectionViewCell
    
        if row == 0 {
            
            cell.mLabel.text = "Solved"
            
            if issueTypeSearch == 0 {
                cell.mLabel.textColor = Constants.Colors.orange
                cell.mImage.image = UIImage(named: "ic_handshake_on")
            }
            else{
                
                cell.mLabel.textColor = UIColor.black
                cell.mImage.image = UIImage(named: "ic_handshake")
            }
        }
        else if row == 1 {
            
            cell.mLabel.text = "Unsolved"
            
            if issueTypeSearch == 1 {
                cell.mLabel.textColor = Constants.Colors.orange
                cell.mImage.image = UIImage(named: "ic_sad_on")
            }
            else{
                cell.mLabel.textColor = UIColor.black
                cell.mImage.image = UIImage(named: "ic_sad")
            }
        }
        else if row == 2 {
            
            cell.mLabel.text = "Answered"
            
            if issueTypeSearch == 2 {
                cell.mLabel.textColor = Constants.Colors.orange
                cell.mImage.image = UIImage(named: "ic_happy_on")
            }
            else{
                cell.mLabel.textColor = UIColor.black
                cell.mImage.image = UIImage(named: "ic_happy")
            }
        }
        else if row == 3 {
            
            cell.mLabel.text = "Unanswered"
            
            if issueTypeSearch == 3 {
                cell.mLabel.textColor = Constants.Colors.orange
                cell.mImage.image = UIImage(named: "ic_question_on")
            }
            else{
                cell.mLabel.textColor = UIColor.black
                cell.mImage.image = UIImage(named: "ic_question")
            }
        }
        
        return cell
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanyProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        
        //2.00 was just extra spacing I wanted to add to my cell.
        let totalCellWidth = cellWidth*4 + 2.00 * (4-1)
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        if (totalCellWidth < contentWidth) {
            //If the number of cells that exist take up less room than the
            // collection view width... then there is an actual point to centering the.
            
            //Calculate the right amount of padding to center the cells.
            let padding = (contentWidth - totalCellWidth) / 2.0
            return UIEdgeInsetsMake(0, padding, 0, padding)
        } else {
            //Pretty much if the number of cells that exist take up
            // more room than the actual collectionView width there is no
            // point in trying to center them. So we leave the default behavior.
            return UIEdgeInsetsMake(0, 70, 0, 70)
        }

    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        
        return CGSize(width: 70, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if row == 0 {
            
            statusIds.removeAll()
            statusIds.append(3)
        }
        else if row == 1 {
            statusIds.removeAll()
            statusIds.append(4)
        }
        else if row == 2 {
            statusIds.removeAll()
            statusIds.append(5)
        }
        else if row == 3 {
            statusIds.removeAll()
            statusIds.append(2)
        }
        
        issueTypeSearch = row
        
        collectionView.reloadData()
        
        getIssuesReport()
    }
}

// MARK: - UITableViewDataSource

extension CompanyProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1{
            
            return 4
        }
        else{
            
            if self.companyIssues.count == 0 {
                
                self.problemsTableView.separatorStyle = .none
                self.problemsTableView.backgroundView?.isHidden = false
                
            } else {
                
                self.problemsTableView.separatorStyle = .singleLine
                self.problemsTableView.backgroundView?.isHidden = true
            }
            
            return companyIssues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if tableView.tag == 1 {
        
            if row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: companyCellID, for: indexPath) as! CompanyCell
                
                cell.imgLogo.image = company.validateAverageImage()
                
                cell.lblName.text = company.name
                
                cell.selectionStyle = .none
                
                return cell
                
            }
            else if row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                
                cell.imageView?.image = UIImage(named: "ic_domain")
                
                if company.webSite.isEmpty {
                
                    cell.textLabel?.text = "Não informado"
                }
                else{
                    cell.textLabel?.text = company.webSite
                }
                
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
                
                cell.selectionStyle = .none
                
                return cell
            }
            else if row == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                
                cell.imageView?.image = UIImage(named: "ic_marker")
                
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
                
                if company.city != nil && !company.city.isEmpty {
                    
                    if company.country != nil && !company.country.isEmpty {
                        
                        cell.textLabel?.text = company.city + "/" + company.country
                    }
                    else{
                        cell.textLabel?.text = company.city
                    }
                }
                else if company.country != nil && !company.country.isEmpty {
                    cell.textLabel?.text = company.country
                }
                else{
                    
                    cell.textLabel?.text = "Não informado"
                }
                
                cell.selectionStyle = .none
                
                return cell
                
            }
            else if row == 3{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: collectionTableViewCellID, for: indexPath) as! CollectionTableViewCell
                
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                
                cell.collectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
                
                cell.selectionStyle = .none
                
                return cell
                
            }
        }
        else{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: problemsTableViewCellID, for: indexPath) as! ProblemsTableViewCell
            
            let issue = companyIssues[row]
            
            cell.companyLogo.isHidden = true
            
            cell.companyName.text = issue.company.name
            
            let date = issue.creationDate.toDate()
            
            let format = NSLocalizedString("DATE_FORMAT", comment: "")
            
            cell.problemDate.text = DateHelper.formatDate(date: date, withFormat: format)
            
            cell.problemSubject.text = issue.subject
            cell.problemStatus.text = issue.status.name
            
            cell.selectionStyle = .none
            
            return cell
            
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension CompanyProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        
        if tableView.tag == 1 {
        
            if row == 0 {
                return 80
            }
            else if row == 1 || row == 2{
                return 44
            }
            else {
                return 75
            }
        }
        else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 2 {
            
            let row = indexPath.row
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let svc = storyboard.instantiateViewController(withIdentifier: "ProblemDetailsViewControllerID") as! ProblemDetailsViewController
            
            let issue = companyIssues[row]
            
            svc.issue = issue
            svc.isFromCompanyDetails = true
            
            self.navigationController?.pushViewController(svc, animated: true)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
