//
//  MainViewController.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-09.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController,CLLocationManagerDelegate  {
    
    
    
    
    @IBOutlet weak var mapui: MKMapView!
    
    var locationManager = CLLocationManager ()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last?.coordinate else
        {
            return
        }
        
        // Set the map region to the user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapui.setRegion(region, animated: true)
        
        // Add an annotation for the current location
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation
        annotation.title = "Current Location"
        mapui.addAnnotation(annotation)
        
        // Stop updating location to conserve battery
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        // Configure location manager and start updating location

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapui.showsUserLocation = true
    }
    
    func navigateToMapScene(cityName: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
            
            // Call a method in MapViewController to handle navigation based on city name
            mapViewController.convertAddress(cityName: cityName)
            
            navigationController?.pushViewController(mapViewController, animated: false)
            
        }}
    func navigateToNewsScene(cityName: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
        
        if let newsViewController = storyboard.instantiateViewController(withIdentifier: "News") as? NewsTableViewController {
            // Call a method in NewsViewController to handle navigation based on city name

            newsViewController.getCityNews(cityName: cityName)
            
            navigationController?.pushViewController(newsViewController, animated: false)
            
        }
        
    }
    func navigateToWhetherScene(cityName: String){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
            
            // Call a method in WeatherViewController to handle navigation based on city name
            weatherViewController.getWeatherData(cityName: cityName)
            
            navigationController?.pushViewController(weatherViewController, animated: false)
            
        }
        
    }
    
    
    @IBAction func locationDetails(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter Your Destination", preferredStyle: .alert)
        
        
        alertController.addTextField { (cityTextField) in
            cityTextField.placeholder = "Enter city name"
        }
        
        // Define actions for different navigation options
        let newsAction = UIAlertAction(title: "News", style: .default) { (_) in
            // Retrieve the city name entered by the user
            if let cityName = alertController.textFields?[0].text {
                // Geocode the city name to get coordinates
                self.navigateToNewsScene(cityName: cityName)
                
            }
        }
        let mapAction = UIAlertAction(title: "Map", style: .default) { (_) in
            // Retrieve the city name entered by the user
            if let cityName = alertController.textFields?[0].text {
                // Geocode the city name to get coordinates
                self.navigateToMapScene(cityName: cityName)
            }
        }
        let weatherAction = UIAlertAction(title: "Weather", style: .default) { (_) in
            // Retrieve the city name entered by the user
            if let cityName = alertController.textFields?[0].text {
                // Geocode the city name to get coordinates
                self.navigateToWhetherScene(cityName: cityName)
            }
        }
        
        // Add the action to the alert controller
        alertController.addAction(newsAction)
        alertController.addAction(weatherAction)
        alertController.addAction(mapAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
        
    }
}
