//
//  NetworkManager.swift
//  weather
//
//  Created by Дарья on 18/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

class NetworkService {

    let configuration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func getForecast(completion: @escaping (Result<Forecast, Error>) -> Void) {
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=08001,es&units=metric&appid=b90fa5d2cbf008583f5ec992c2cdcd12") else { return }
        
        session.dataTask(with: url) { [weak self] data, _, error in
            
            if error == nil, let data = data {
                do {
                    let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                    print(forecast.weather.description, forecast.main.temperature, forecast.date)
                    
                    print(forecast.weather.description.crop())
                    
                    completion(.success(forecast))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

extension String {
    func crop() -> String {
        let halfCropped = self.trimmingCharacters(in: .init(charactersIn: "[weather.Weather(description: \""))
        let fullyCropped = halfCropped.trimmingCharacters(in: .init(charactersIn: "\")]"))
        return fullyCropped
    }
}


