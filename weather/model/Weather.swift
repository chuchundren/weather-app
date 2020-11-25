//
//  Weather.swift
//  weather
//
//  Created by Дарья on 18/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

struct Forecast2: Codable {
    let main: Main2
    let date: Int
    let weather: [Weather2]
 
    enum CodingKeys: String, CodingKey {
        case main
        case date = "dt"
        case weather
    }
}

struct Weather2: Codable {
    let description: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        description = try values.decode(String.self, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case description = "main"
    }
}

struct Main2: Codable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
