//
//  WeatherViewController.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-09.
//

import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var cityName: UILabel!
    
    
    @IBOutlet weak var destinationCity: UILabel!
    
    
    
    @IBOutlet weak var weatherInfo: UILabel!
    
    
    
    @IBOutlet weak var weatherInfoImage: UIImageView!
    
    
    
    @IBOutlet weak var temperature: UILabel!
    
    
    @IBOutlet weak var humidity: UILabel!
    
    
    
    
    @IBOutlet weak var windSpeed: UILabel!
    
    
    
    //Button Action for Getting Destination City
    @IBAction func getDestinationCity(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter the city", message: " ", preferredStyle: .alert)
        
        alert.addTextField()
        alert.textFields![0].placeholder = "City Name"
        alert.textFields![0].keyboardType = UIKeyboardType.namePhonePad
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive,handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default ,handler: {(action) in
            let cityName = alert.textFields![0].text
            self.getWeatherData(cityName: cityName!)
            
        }))
        
        self.present(alert, animated: true)
    }
    //Function to Fetch Weather Data
    func getWeatherData(cityName: String) {
        //Step 1
        //API session
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=6a450b730898eca3caa74b052f39a6a1&units=metric"
        
        // Note this shouls be a VAR in when used in an application as the URL value will change with each call!
        
        // Create an instance of a URLSession Class and assign the value of your URL to the The URL in the Class
        let urlSession = URLSession(configuration:.default)
        let url = URL(string: urlString)
        
        
        // Check for Valid URL
        if let url = url {
            // Create a variable to capture the data from the URL
            let dataTask = urlSession.dataTask(with: url) {(data, response, error) in
                // If URL is good then get the data and decode
                if let data = data {
                    print (data)
                    let jsonDecoder = JSONDecoder()
                    do {
                        // Create an variable to store the structure from the decoded stucture
                        let readableData = try jsonDecoder.decode(WeatherDetails.self, from: data)
                        // Print the data in various formate
                        
                        print (readableData.wind)
                        print (readableData.name)
                        print (readableData.main)
                        
                        // Update UI on the main thread with the received weather data
                        DispatchQueue.main.sync{
                            self.cityName.text = readableData.name
                            self.destinationCity.text = readableData.name
                            self.weatherInfo.text = readableData.weather[0].description
                            self.temperature.text = "\(Int(readableData.main.temp-273.15)) °C"
                            let imageUrlString = "https://openweathermap.org/img/w/"+readableData.weather[0].icon+".png"
                            if let imageUrl = URL(string: imageUrlString) {
                                if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                                    self.weatherInfoImage.image = image
                                }
                            }
                            self.humidity.text = "\(readableData.main.humidity)%"
                            self.windSpeed.text = "\(readableData.wind.speed) m/s"
                        }
                        
                        
                    }
                    //Catch the Broken URL Decode
                    catch {
                        print ("Can't Decode")
                    }
                }
            }
            dataTask.resume()// Resume the datatask method
            
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
