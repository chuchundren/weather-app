//
//  Forecast.swift
//  weather
//
//  Created by Дарья on 27.11.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let main: Main
    let date: Int
    let weather: [Weather]
    let city: String
 
    enum CodingKeys: String, CodingKey {
        case main
        case date = "dt"
        case weather
        case city = "name"
    }
}

struct Weather: Codable {
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case description = "main"
    }
}

struct Main: Codable {
    let temperature: Float
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
