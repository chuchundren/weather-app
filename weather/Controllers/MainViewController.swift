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
    
    //MARK: - Properties
    
    var networkService = NetworkService()
    var locationManager: CLLocationManager?
    
    var mainViewModel: MainViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    var defaultCity = "Barcelona"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DispatchQueue.global().async { [weak self] in
            self?.fetchWeather(for: self!.defaultCity.replaceSpaceAndTrim())
        }
    }
    
    //MARK: - View Methods
    
    func updateView() {
        if let viewModel = mainViewModel {
            setWeather(with: viewModel)
            activityIndicator.stopAnimating()
        }
    }
    
    func setWeather(with viewModel: MainViewModel) {
        weatherLabel.text = viewModel.weatherDescription
        temperatureLabel.text = viewModel.temperature
        placeAndDateLabel.text = "\(viewModel.place), \(viewModel.date)"
        weatherImage.image = viewModel.weatherImage
    }
    
    //MARK: - Helper Methods
    
    func fetchWeather(for city: String) {
        networkService.loadWeather(forCity: city, completion: { [weak self] (result) in
            switch result {
            case .success(let forecast):
                self?.mainViewModel = MainViewModel(forecast: forecast)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
    func checkLocationAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager!.startUpdatingLocation()
            print(locationManager!.location!)
            print("Authorized")
        case .notDetermined:
            locationManager!.requestWhenInUseAuthorization()
            print("not determined")
        default:
            fetchWeather(for: defaultCity)
            print("access is not enabled")
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        checkLocationAutorization()
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
                    self.fetchWeather(for: locationCity.replaceSpaceAndTrim())
                }
                locationManager!.stopUpdatingLocation()
                print("stopped updating")
                locationManager = nil
            }
        }
    }
    
    
}
