//
//  MasterViewController.swift
//  MEMKO-1.0
//
//  Created by 陳致元 on 2018/5/27.
//  Copyright © 2018年 Chih-Yuan Chen. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    var detailViewController: DetailViewController? = nil
    var aircraftList = [Aircraft]()
    var filteredaircraftList = [Aircraft]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func logout(_sender: UIBarButtonItem){
       self.performSegue(withIdentifier: "index", sender: self)
    }
   
    
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Aircraft"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "A330", "B737", "A320"]
        searchController.searchBar.delegate = self
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        let url=URL(string:"https://ft-akira1990921.oraclecloud2.dreamfactory.com/api/v2/memko/_table/TEST?api_key=34edd2832405479e56193b1f6f59a188bb9b38985d27bf35bb1e220843daf788")
        aircraftList = []
        do {
            let allContactsData = try Data(contentsOf: url!)
            let allContacts = try JSONSerialization.jsonObject(with: allContactsData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : NSArray]
            if let arrJSON = allContacts["resource"] {
                
                for index in 0...arrJSON.count-1 {
                    let aObject = arrJSON[index] as! [String: Any]
                    
                    let mymodel = Aircraft(AC_TYPE: aObject["AC_TYPE"] as! String, AC: aObject["AC"] as! String, AC_SERIES: aObject["AC_SERIES"] as! String, AC_SN: aObject["AC_SN"] as! String, STATUS: aObject["STATUS"] as! String )
                    aircraftList.append(mymodel)
                    filteredaircraftList.append(mymodel)
                }
                
                tableView.reloadData()
                
            }
            
        }catch {
            
        }
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
                
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            tableView.reloadData()
           
        }
    }
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed{
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredaircraftList.count, of: aircraftList.count)
            return filteredaircraftList.count
        }
        
        searchFooter.setNotFiltering()
        return aircraftList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let aircraft: Aircraft
        if isFiltering() {
            aircraft = filteredaircraftList[indexPath.row]
        } else {
            aircraft = aircraftList[indexPath.row]
        }
        cell.textLabel!.text = aircraft.AC
       cell.textLabel?.textColor = UIColor.red
        cell.detailTextLabel!.text = aircraft.AC_TYPE
        cell.detailTextLabel?.textColor = UIColor.red
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let aircraft: Aircraft
                if isFiltering() {
                    aircraft = filteredaircraftList[indexPath.row]
                } else {
                    aircraft = aircraftList[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailaircraft = aircraft
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredaircraftList = aircraftList.filter({( aircraft : Aircraft) -> Bool in
            let doesCategoryMatch = (scope == "All") || (aircraft.AC_TYPE == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && aircraft.AC.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
