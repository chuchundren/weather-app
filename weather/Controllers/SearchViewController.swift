//
//  SearchViewController.swift
//  weather
//
//  Created by Дарья on 25.11.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Properties
    
    var networkService = NetworkService()
    
    var cityArray: [String] = ["Barcelona"]
    var placemarks = [Country]()
    
    let searchController = UISearchController(searchResultsController: nil)

    var filteredCities: [String] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search weather for city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        networkService.loadPlacemarks { result in
            switch result {
            case .success(let placemarks):
                for (key, value) in placemarks {
                    self.placemarks.append(Country(countryName: key, cities: value))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func filterContentForSearchText(_ searchText: String, countryName: String? = nil) {
        for i in 0..<placemarks.count {
            placemarks[i].searchText = searchText
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let mainViewController = navigationController.viewControllers.first as? MainViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        let city = placemarks[indexPath.section].cities[indexPath.row]
        mainViewController.defaultCity = city
        mainViewController.fetchWeather(for: city)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks[section].cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let city = placemarks[indexPath.section].cities[indexPath.row]
        
        cell.textLabel?.text = city
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return placemarks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return placemarks[section].countryName
    }
    
}

//MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
