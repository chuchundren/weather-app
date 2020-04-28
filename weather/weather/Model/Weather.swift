//
//  Weather.swift
//  weather
//
//  Created by Дарья on 18/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let main: Main
    let date: Int
    let weather: [Weather]
 
    enum CodingKeys: String, CodingKey {
        case main
        case date = "dt"
        case weather
    }
}

struct Weather: Codable {
    let description: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        description = try values.decode(String.self, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case description = "main"
    }
}

struct Main: Codable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}
//
//extension Weather {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        description = try values.decode(String.self, forKey: .description)
//    }
//}
