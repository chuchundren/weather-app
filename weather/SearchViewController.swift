//
//  SearchViewController.swift
//  weather
//
//  Created by Дарья on 25.11.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var networkService = NetworkService()
    var cityArray: [String] = ["Barcelona"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let mainViewController = navigationController.viewControllers.first as? MainViewController,
              let index = tableView.indexPathForSelectedRow?.row else { return }
        mainViewController.defaultCity = cityArray[index]
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        if let cityString = searchBar.text, !cityString.isEmpty {
            networkService.loadWeather(forCity: cityString) { [weak self] result in
                switch result {
                case .success(_):
                    self?.cityArray.append(cityString)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error occured: \(error), possibly wrong url")
                }
            }
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cityArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent"
    }
    
}
