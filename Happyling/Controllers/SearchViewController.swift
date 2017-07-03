//
//  SearchViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 08/12/16.
//  Copyright © 2016 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol CreateCompanyProtocol{
 
    func createCompany()
}

class SearchViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    var searchActive: Bool = false
    
    var start: Int = 0
    var pageSize: Int = 10
    var recordsTotal: Int!
    
    var companies: [Company] = []
    var filteredCompanies: [Company] = []
    
    var mParams: [String: Any] = [:]
    
    var isFromIssues : Bool = false
    
    var delegate: SelectCompanyProtocol!
    
    let topMessage = "Happyling"
    let bottomMessage = "No companies found."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Companies"
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        setupSearchController()
        
        setupTableView()
        
        showHUD()
        
        getCompanies()
    }
    
    func setupSearchController(){

        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        tableView.tableHeaderView = searchBar
    }

    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.register(UINib(nibName: "CellNotFoundCell", bundle: nil), forCellReuseIdentifier: "CellNotFoundCellID")
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCellID")
        
        let emptyBackgroundView = EmptyBackgroundView(image: UIImage(), top: topMessage, bottom: bottomMessage)
        
        tableView.backgroundView = emptyBackgroundView
        tableView.backgroundView?.isHidden = true
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func showInfiniteScrollViewInFooter() {
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
//        let height = bounds.size.height
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        footerView.backgroundColor = UIColor.clear
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()

        actInd.center = CGPoint(x: width/2, y: 22)
        actInd.color = Constants.Colors.orange
        
        actInd.startAnimating()
        
        footerView.addSubview(actInd)
        
        self.tableView.tableFooterView = footerView;
        
    }
    
    func removedInfiniteScrollViewInFooter(){
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getCompanies(){
        
        mParams["start"] = start
        mParams["pageSize"] = pageSize
        //        mParams["sortBy"] = ""
        //        mParams["direction"] = ""
        //        mParams["name"] = ""
        
        Alamofire.request(CompanyRouter.GetCompany(mParams)).responseJSON { response in
            
            self.hideHUD()
            self.removedInfiniteScrollViewInFooter()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let getCompanyResponse = Mapper<GetCompanyResponse>().map(JSON: json as! [String: Any])
                
                if getCompanyResponse?.data != nil {
                    
                    self.companies.append(contentsOf: getCompanyResponse!.data)
                    self.recordsTotal = getCompanyResponse?.responseAttrs.recordsTotal
                    
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
                else if getCompanyResponse!.responseAttrs.errorMessage != nil {
                    
                    print(getCompanyResponse!.responseAttrs.errorMessage)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getCompaniesByName(name: String){
        
        var params: [String: Any] = [:]
        
        params["name"] = name
        
        Alamofire.request(CompanyRouter.GetCompany(params)).responseJSON { response in
            
            self.hideHUD()
            self.removedInfiniteScrollViewInFooter()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let getCompanyResponse = Mapper<GetCompanyResponse>().map(JSON: json as! [String: Any])
                
                if getCompanyResponse?.data != nil {
                    
                    self.companies.append(contentsOf: getCompanyResponse!.data)
                    self.recordsTotal = getCompanyResponse?.responseAttrs.recordsTotal
                    
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
                else if getCompanyResponse!.responseAttrs.errorMessage != nil {
                    
                    print(getCompanyResponse!.responseAttrs.errorMessage)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToCompanyProfile" {
            
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let company: Company
            
            if searchActive {
                company = filteredCompanies[row]
            } else {
                company = companies[row]
            }
            
            let svc = segue.destination as! CompanyProfileViewController
                
            svc.company = company
        }
        else if segue.identifier == "segueToCompanySimple" {
            
            let svc = segue.destination as! CreateSimpleCompanyViewController
            
            svc.delegate = self
        }
    }
}

extension SearchViewController: CreateCompanyProtocol{
    
    func createCompany() {
        
        searchBar.text = ""
        searchActive = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        companies.removeAll()
        filteredCompanies.removeAll()
        
        showHUD()
        getCompanies()
    }
}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableView.backgroundView?.isHidden = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        tableView.backgroundView?.isHidden = false
        searchBar.setShowsCancelButton(false, animated: true)
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchActive = false;
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCompanies = companies.filter { company in
            return company.name.lowercased().contains(searchText.lowercased())
        }
        
        self.tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
        
            if ( filteredCompanies.count == 0) {
                return 1
            }
            
            return filteredCompanies.count
        }
        else {
            
            if self.companies.count == 0 {
                self.tableView.backgroundView?.isHidden = false
            }
            else {
                self.tableView.backgroundView?.isHidden = true
            }
            
            return companies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchActive && filteredCompanies.count == 0 {
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotFoundCellID", for: indexPath)
            
            cell.textLabel?.text = "You can't find the company ? Click here"
            
            return cell
            
        }
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCellID", for: indexPath) as! CompanyCell
        
        let company: Company
        
        if searchActive {            
            company = filteredCompanies[row]
        } else {
            company = companies[row]
        }
        
        cell.lblName.text = company.name
        
        if company.average != nil {
        
            if company.average > 4 {
                cell.imgLogo.image = UIImage(named: "ic_orange")
            }
            else if company.average > 3 {
                cell.imgLogo.image = UIImage(named: "ic_yellow_dark")
            }
            else if company.average > 2 {
                cell.imgLogo.image = UIImage(named: "ic_yellow")
            }
            else if company.average > 1 {
                cell.imgLogo.image = UIImage(named: "ic_blue")
            }
            else {
                cell.imgLogo.image = UIImage(named: "ic_purple")
            }
        }
        else {
            
            cell.imgLogo.image = UIImage(named: "ic_orange")
            
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        if row == self.companies.count - 1 && self.recordsTotal != self.companies.count {
            
            self.start += pageSize
            
            showInfiniteScrollViewInFooter()
            
            getCompanies()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            let company = companies[indexPath.row]
            
            delegate.selectedCompany(company: company)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
            if searchActive && filteredCompanies.count == 0 {
            
                performSegue(withIdentifier: "segueToCompanySimple", sender: self)
                
            }
            else{
                performSegue(withIdentifier: "segueToCompanyProfile", sender: self)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
