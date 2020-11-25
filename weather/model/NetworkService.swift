//
//  NetworkManager.swift
//  weather
//
//  Created by Дарья on 18/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkService {

    let decoder = JSONDecoder()
    
    func loadWeather(forCity city: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=d39dfcc6ec93fc22843a1dfecd9d0b99") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data, error == nil {
                do {
                    let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                    completion(.success(forecast))
                    print(forecast.cityName)
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}
