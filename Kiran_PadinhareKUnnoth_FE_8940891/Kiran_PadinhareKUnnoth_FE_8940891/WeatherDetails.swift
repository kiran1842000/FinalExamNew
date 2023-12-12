//
//  WeatherDetails.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-10.
//

import Foundation

struct WeatherDetails: Codable {
    let name: String
      let weather: [Weather]
    let main: Main
      let wind: Wind
}
  
struct Weather: Codable {
    let description: String
    let icon: String
}

    struct Main: Codable {
           let temp: Double
    let humidity: Double
}
 
        struct Wind: Codable {
    let speed: Double
}

