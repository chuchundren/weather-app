//
//  ViewController.swift
//  weather
//
//  Created by Дарья on 15/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var placeAndDateLabel: UILabel!
    
    var networkService = NetworkService()
    
    var defaultCity = "Barcelona"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather(for: defaultCity)
        checkLocationAutorization()
    }
    
    func fetchWeather(for city: String) {
        networkService.loadWeather(forCity: city, completion: { [weak self] (result) in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.setWeather(with: forecast)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func setWeather(with forecast: Forecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let date = Date.init(timeIntervalSince1970: TimeInterval(forecast.date))
        
        weatherLabel.text = forecast.weather[0].mainDescription
        temperatureLabel.text = "\(forecast.description.temperature.convertKelvinToCelsium())˚C"
        placeAndDateLabel.text = "\(forecast.cityName), \(dateFormatter.string(from: date))"
        
        switch forecast.weather[0].mainDescription {
        case "Clear":
            weatherImage.image = UIImage(named: "sunny")
        case "Rain":
            weatherImage.image = UIImage(named: "raining")
        case "Clouds":
            weatherImage.image = UIImage(named: "cloudy")
        default:
            weatherImage.image = UIImage(named: "cloudy")
        }
    }
    

}

