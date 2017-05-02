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


class SearchViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var start: Int = 0
    var pageSize: Int = 10
    var recordsTotal: Int!
    
    var companies: [Company] = []
    var filteredCompanies: [Company] = []
    
    var params: [String: Any] = [:]
    
    var isFromIssues : Bool = false
    
    var delegate: SelectCompanyProtocol!
    
    var refreshControl: UIRefreshControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Companies"
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        setupSearchController()
        
        showHUD()
        
        getCompanies()
        
        setupPullToRefresh()
        
        setupTableView()
    }
    
    func setupSearchController(){
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func setupPullToRefresh(){
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getCompanies), for: .valueChanged)
    }

    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.register(UINib(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCellID")
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.addSubview(refreshControl)
    }
    
    func showInfiniteScrollViewInFooter() {
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
//        let height = bounds.size.height
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        footerView.backgroundColor = UIColor.clear
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()

        actInd.center = CGPoint(x: width/2, y: 22)
        actInd.color = UIColor(red: 0.0/255.0, green: 162.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        
        actInd.startAnimating()
        
        footerView.addSubview(actInd)
        
        self.tableView.tableFooterView = footerView;
        
    }
    
    func removedInfiniteScrollViewInFooter(){
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func getCompanies(){
        
        if params.keys.count == 0 {
            
            params["start"] = start
            params["pageSize"] = pageSize
//              params["sortBy"] = ""
//              params["direction"] = ""
//              params["name"] = ""
        }
        
        Alamofire.request(CompanyRouter.GetCompany(params)).responseJSON { response in
            
            self.hideHUD()
            self.removedInfiniteScrollViewInFooter()
            
            if self.refreshControl.isRefreshing {
                
                self.refreshControl.endRefreshing()
            }
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let getCompanyResponse = Mapper<GetCompanyResponse>().map(JSON: json as! [String: Any])
                
                if getCompanyResponse?.data != nil {
                    
                    self.companies = getCompanyResponse!.data
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
            
            if searchController.isActive && searchController.searchBar.text != "" {
                company = filteredCompanies[row]
            } else {
                company = companies[row]
            }
            
            let svc = segue.destination as! CompanyProfileViewController
                
            svc.company = company
        }
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredCompanies = companies.filter { company in
            return company.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCompanies.count
        }
        
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCellID", for: indexPath) as! CompanyCell
        
        let company: Company
        
        if searchController.isActive && searchController.searchBar.text != "" {
            company = filteredCompanies[row]
        } else {
            company = companies[row]
        }
        
        cell.imgLogo.backgroundColor = Constants.Colors.oranage
        cell.lblName.text = company.name
        
        
        cell.imgLogo.layer.cornerRadius = cell.imgLogo.frame.size.width / 2
        cell.imgLogo.clipsToBounds = true
        
        return cell
    }
    
    
}

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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            let company = companies[indexPath.row]
            
            delegate.selectedCompany(company: company)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            performSegue(withIdentifier: "segueToCompanyProfile", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
