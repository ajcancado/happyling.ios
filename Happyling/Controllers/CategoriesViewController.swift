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
    
    var companyCategories: [CompanyCategorie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Categories"
        
        setupTableView()
        
        getCategories()
    }
    
    func setupTableView(){
        
        tableView.backgroundColor = Constants.Colors.gray
        
        tableView.tableFooterView = UIView(frame: .zero)
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
                    
                    print(companyCategoriesResponse?.responseAttrs.errorMessage!)
                    
                }
                
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
            
        }
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellID", for: indexPath)
        
        let companyCategorie = companyCategories[row]
        
        cell.textLabel?.text = companyCategorie.name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewControllerID") as!SearchViewController
        
        var params: [String: Any] = [:]
        
        params["categoryId"] = companyCategories[row].id
        
        viewController.params = params
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
