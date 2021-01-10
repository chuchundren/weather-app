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
                    let forecast = try self.decoder.decode(Forecast.self, from: data)
                    completion(.success(forecast))
                    print(forecast.city)
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func loadPlacemarks(completion: @escaping (Result<[String: [String]], Error>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/russ666/all-countries-and-cities-json/6ee538beca8914133259b401ba47a550313e8984/countries.json") else { return }
        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, _, error) in
            if let data = data, error == nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String]] {
                        completion(.success(json))
                    }
                } catch {
                    print("Failed to load cities: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}
