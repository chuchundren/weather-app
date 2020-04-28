//
//  ViewController.swift
//  weather
//
//  Created by Дарья on 15/03/2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var placeAndDateLabel: UILabel!
    
    var forecast: Forecast?
    var networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getForecast(completion: { [weak self] (result) in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.setWeather(with: forecast)
                }
            case .failure(let error):
                print("failed: \(error.localizedDescription)")
            }

        })
    }

    func setWeather(with forecast: Forecast) {
        
        let trueDate = Date.init(timeIntervalSince1970: TimeInterval(forecast.date))
        let date = "\(trueDate.convertToDay()) \(trueDate.convertToMonth())"
        
        weatherLabel.text = forecast.weather.description.crop()
        temperatureLabel.text = "\(Int(forecast.main.temperature))˚C"
        placeAndDateLabel.text = "Barcelona, \(date)"
        
        switch forecast.weather.description.crop() {
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    
}


extension Date {
    func convertToDay() -> String {
        let fullComponents = self.description.components(separatedBy: " ")
        let dateComponents = fullComponents[0].components(separatedBy: "-")
        let day = dateComponents[2]
        switch day {
        case "01", "21", "31":
            return "\(day)st"
        case "02", "22":
            return "\(day)nd"
        case "03", "23":
            return "\(day)rd"
        default:
            return "\(day)th"
        }
    }
    
    func convertToMonth() -> String {
        let fullComponents = self.description.components(separatedBy: " ")
        let dateComponents = fullComponents[0].components(separatedBy: "-")
        let month = dateComponents[1]
        switch month {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "probably not a month"
        }
    }
}

