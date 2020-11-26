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

{"coord":
    {"lon":-0.13,"lat":51.51},
    "weather":
    [{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],
    "base":"stations",
    "main":
    {"temp":278.68,
        "feels_like":275.82,
        "temp_min":277.59,
        "temp_max":280.37,
        "pressure":1021,
        "humidity":72},
    "visibility":10000,
    "wind":{"speed":1.44,"deg":35},
    "clouds":{"all":0},
    "dt":1606426619,
    "sys":{"type":3,"id":268730,"country":"GB","sunrise":1606376236,"sunset":1606406340},
    "timezone":0,
    "id":2643743,
    "name":"London",
    "cod":200}
