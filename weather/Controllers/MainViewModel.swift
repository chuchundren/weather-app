//
//  MainViewModel.swift
//  weather
//
//  Created by Дарья on 18.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit


class MainViewModel {
    
    // MARK: - Properties
    var networkService = NetworkService()
    var forecast: Forecast!
    
    var weatherDescription: String {
        return forecast.weather[0].description
    }
    
    var temperature: String {
        return "\(forecast.main.temperature.convertKelvinToCelsium())˚C"
    }
    
    var place: String {
        return forecast.city
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let date = Date.init(timeIntervalSince1970: TimeInterval(forecast.date))
        return dateFormatter.string(from: date)
    }
    
    var weatherImage: UIImage {
        switch forecast.weather[0].description {
        case "Clear":
            return UIImage(named: "sunny")!
        case "Rain":
            return UIImage(named: "raining")!
        case "Clouds":
            return UIImage(named: "cloudy")!
        default:
            return UIImage(named: "cloudy")!
        }
    }
    
    var navTitle: String {
        return forecast.city
    }
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
}
