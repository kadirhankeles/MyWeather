//
//  WeatherService.swift
//  WeatherMyApp
//
//  Created by Kadirhan Keles on 15.08.2023.
// 07de6e352cc77e781ec578c937639967


import Foundation

protocol WeatherServiceInterface {
    func fetchAllDatas(city: String, completion: @escaping(Result<(City, [List]), NetworkError>) -> Void)
}

enum WeatherServiceEndPoint: String {
    case BASE_URL = "https://api.openweathermap.org/data/2.5"
    case FORECAST_PATH = "/forecast"
    
    static func forecastURL(city: String, apiKey: String) -> String {
        let urlString = "\(BASE_URL.rawValue)\(FORECAST_PATH.rawValue)?q=\(city)&appid=\(apiKey)&units=metric"
        return urlString
    }
}

enum NetworkError: Error {
    case urlError
    case canNotParseData
}

final class WeatherService: WeatherServiceInterface {
    
    func fetchAllDatas(city: String, completion: @escaping(Result<(City, [List]), NetworkError>) -> Void) {
        let apiKey = "07de6e352cc77e781ec578c937639967"
        let forecastURL = WeatherServiceEndPoint.forecastURL(city: city, apiKey: apiKey)
        
        guard let url = URL(string: forecastURL) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Error: \(error)")
                completion(.failure(.canNotParseData))
                return
            }

            if let data = data {
                do {
                    let resultData = try JSONDecoder().decode(WeatherData.self, from: data)
                    if let city = resultData.city, let list = resultData.list {
                        completion(.success((city, list)))
                    } else {
                        completion(.failure(.canNotParseData))
                    }
                } catch {
                    print("JSON Decode Error: \(error)")
                    completion(.failure(.canNotParseData))
                }
            } else {
                completion(.failure(.canNotParseData))
            }
        }.resume()
    }
}
    
    

