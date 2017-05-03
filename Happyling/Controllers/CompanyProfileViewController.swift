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

    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
        
    @IBOutlet weak var mLabelName: UILabel!
    
    @IBOutlet weak var mLabelReplyTime: UILabel!
    
    @IBOutlet weak var mLabelWebsite: UILabel!
    
    @IBOutlet weak var mLabelAddress: UILabel!
    
    var company: Company!
    
    var statusIds: [Int] = []
    
    var companyIssues: [Issue] = []
    
    let topMessage = "Eba..."
    let bottomMessage = "Nenhum problema"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = company.name
        
        setupCompanyInfo()
        
        setupTableView()
        
        statusIds.append(3)
        
        getIssuesReport()
    }
    
    func setupCompanyInfo(){
        
        statusImage.backgroundColor = Constants.Colors.oranage
        statusImage.layer.cornerRadius = statusImage.frame.size.width / 2
        statusImage.clipsToBounds = true
        
        mLabelName.text = company.name
        mLabelReplyTime.text = company.status
        mLabelReplyTime.isHidden = true
        mLabelWebsite.text = company.webSite
        
        if company.city != nil && !company.city.isEmpty {
            
            if company.country != nil && !company.country.isEmpty {
                
                mLabelAddress.text = company.city + "/" + company.country
            }
            else{
                mLabelAddress.text = company.city
            }
        }
        else if company.country != nil && !company.country.isEmpty {
            mLabelAddress.text = company.country
        }
        else{
            
            mLabelAddress.text = ""
        }
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(UINib(nibName: "ProblemsTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
        
    }
    
    func getIssuesReport(){
        
        showHUD()
        
        let userId = SessionManager.getIntegerForKey(key: Constants.SessionKeys.userId)
        
        Alamofire.request(IssueRouter.GetIssues(userId, statusIds)).responseJSON { response in
            
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        
        if row == 0 {
            
            imageView.image = UIImage(named: "ic_handshake")
            label.text = "Solved"
        }
        else if row == 1 {
            
            imageView.image = UIImage(named: "ic_sad")
            label.text = "Unsolved"
        }
        else if row == 2 {
            
            imageView.image = UIImage(named: "ic_happy")
            label.text = "Answered"
        }
        else if row == 3 {
            
            imageView.image = UIImage(named: "ic_question")
            label.text = "Unanswered"
        }
        
        return cell
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CompanyProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        
        //15.00 was just extra spacing I wanted to add to my cell.
        let totalCellWidth = cellWidth*4 + 15.00 * (4-1)
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
            return UIEdgeInsetsMake(0, 40, 0, 40)
        }

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
            statusIds.append(6)
        }
        
        getIssuesReport()
    }
}

// MARK: - UITableViewDataSource

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! ProblemsTableViewCell
        
        let issue = companyIssues[row]
        
        cell.companyLogo.backgroundColor = Constants.Colors.oranage
        cell.companyLogo.layer.cornerRadius = cell.companyLogo.frame.size.width / 2
        cell.companyLogo.clipsToBounds = true
        
        cell.companyName.text = issue.company.name
        
        let date = NSDate(timeIntervalSince1970: issue.creationDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Edit
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDateSelect = dateFormatter.string(from: date as Date)
        print(strDateSelect) //Local time
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = NSTimeZone.local
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        
        cell.problemDate.text = strDateSelect
        
        cell.problemSubject.text = issue.subject
        cell.problemStatus.text = issue.status.name

        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CompanyProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
