//
//  Cities.swift
//  weather
//
//  Created by Дарья on 09.01.2021.
//  Copyright © 2021 chuchundren. All rights reserved.
//

import Foundation


struct Country {
    var countryName: String
    var cities: [String]
    
    var searchText = ""
    
    var filteredCities: [String]  {
        return cities.filter { (city: String) -> Bool in
            city.lowercased().contains(searchText.lowercased())
        }
    }
}
