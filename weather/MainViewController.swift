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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var networkService = NetworkService()
    var locationManager = CLLocationManager()
    
    var defaultCity = "Barcelona"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        checkLocationAutorization()
    }
    
    func fetchWeather(for city: String) {
        networkService.loadWeather(forCity: city, completion: { [weak self] (result) in
            switch result {
            case .success(let forecast):
                DispatchQueue.main.async {
                    self?.setWeather(with: forecast)
                    self?.activityIndicator.stopAnimating()
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
        
        weatherLabel.text = forecast.weather[0].description
        temperatureLabel.text = "\(forecast.main.temperature.convertKelvinToCelsium())˚C"
        placeAndDateLabel.text = "\(forecast.city), \(dateFormatter.string(from: date))"
        
        switch forecast.weather[0].description {
        case "Clear":
            weatherImage.image = UIImage(named: "sunny")
        case "Rain":
            weatherImage.image = UIImage(named: "raining")
        case "Clouds":
            weatherImage.image = UIImage(named: "cloudy")
        default:
            weatherImage.image = UIImage(named: "cloudy")
        }
        
        self.title = forecast.city
    }
    
    func checkLocationAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            print(locationManager.location!)
            print("Authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
        default:
            fetchWeather(for: defaultCity)
            print("access is not enabled")
        }
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update locations: \(locations)")
        if let location = locations.last {
            if location.horizontalAccuracy > 0 {
                CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                    guard error == nil, let placemark = placemarks?.first else { return }
                    guard let locationCity = placemark.locality else { return }
                    print("Current location: \(locationCity)")
                    self.fetchWeather(for: locationCity)
                }
                locationManager.stopUpdatingLocation()
                print("stopped updating")
            }
        }
    }
    
    
}
