//
//  CategoriesViewController.swift
//  Happyling
//
//  Created by Arthur Junqueira Cançado on 29/01/17.
//  Copyright © 2017 Happyling. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class CategoriesViewController: GenericViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SelectCategoryProtocol!
    
    var companyCategories: [CompanyCategorie] = []
    var categoriesFiltered: [CompanyCategorie] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_navigation"))
        
        setupTableView()
        
        setupSearchController()
        
        getCategories()
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupSearchController(){
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

    func getCategories() {
        
        self.showHUD()
        
        Alamofire.request(CompanyRouter.GetCompanyCategories()).responseJSON { response in
            
            self.hideHUD()
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                
                let companyCategoriesResponse = Mapper<GetCompanyCategoriesResponse>().map(JSON: json as! [String: Any])
                
                if companyCategoriesResponse?.data != nil {
                    
                    self.companyCategories = (companyCategoriesResponse?.data)!
                    
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    
                    self.tableView.reloadData()
                    
                }
                else if companyCategoriesResponse?.responseAttrs.errorMessage != nil {
                    
                    print(companyCategoriesResponse!.responseAttrs.errorMessage!)
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        categoriesFiltered = companyCategories.filter { category in
            return category.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - UISearchResultsUpdating

extension CategoriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return categoriesFiltered.count
        }
        
        return companyCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellID", for: indexPath)
        
        let companyCategorie: CompanyCategorie
        
        if searchController.isActive && searchController.searchBar.text != "" {
            companyCategorie = categoriesFiltered[row]
        } else {
            companyCategorie = companyCategories[row]
        }
        
        cell.textLabel?.text = companyCategorie.name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        var companyCategorie: CompanyCategorie
        
        if searchController.isActive && !(searchController.searchBar.text?.isEmpty)! {
            companyCategorie = categoriesFiltered[row]
        } else {
            companyCategorie = companyCategories[row]
        }
        
        if delegate != nil {
            
            delegate.selectCategory(category: companyCategorie)
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let viewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewControllerID") as!SearchViewController
            
            viewController.mParams["categoryId"] = companyCategorie.id

            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
