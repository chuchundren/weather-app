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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=08001,es&units=metric&appid=b90fa5d2cbf008583f5ec992c2cdcd12") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    guard let weatherDetails = json["weather"] as? [[String : Any]], let weatherMain = json["main"] as? [String : Any] else { return }
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let description = (weatherDetails.first?["main"] as? String)?.capitalizingFirstLetter()
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp)
                    }
                } catch {
                    print("we had aan error retriving the weather")
                }
            }
        }
        task.resume()
    }
    
    func setWeather(weather: String?, description: String?, temp: Int) {
        weatherLabel.text = description ?? "..."
        temperatureLabel.text = "\(temp)˚C"
        switch weather {
        case "Sunny":
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

