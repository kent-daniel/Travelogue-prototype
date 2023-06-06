//
//  weatherDataModel.swift
//  Travelogue
//
//  Created by kent daniel on 4/6/2023.
//
struct WeatherData: Codable {
    let current: CurrentWeather
    let location: WeatherLocation
}

struct WeatherLocation: Codable {
    let name: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
