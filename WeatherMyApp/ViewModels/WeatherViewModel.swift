import Foundation

protocol WeatherViewModelInterface {
    var weatherService: WeatherServiceInterface? { get set }
    var city: City? { get }
    var weatherList: [List] { get }
    var delegate: WeatherViewInterface? { get set }
    func fetchAllDatas(city: String)
    func convertDouble(temp: Double) -> String
    func updateTime() -> String
    func getConditionName(weatherId: Int) -> String
    func convertToHourFormat(from dateString: String) -> String?
    func detailImageView(index: Int) -> String
    
}

class WeatherViewModel: WeatherViewModelInterface {
    
    func detailImageView(index: Int) -> String {
        switch index {
        case 0:
            return "thermometer.high"
        case 1:
            return "thermometer.low"
        case 2:
            return "humidity"
        case 3:
            return "wind"
        default:
            return "cloud"
        }
    }
    
    
    func convertToHourFormat(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateString) {
            let hourFormatter = DateFormatter()
            hourFormatter.dateFormat = "h:mm a"
            return hourFormatter.string(from: date)
        }
        return nil
    }
    
    func getConditionName(weatherId: Int) -> String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud. fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
        
    }
    
    func updateTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy - h:mm a"
        let formattedDateTime = dateFormatter.string(from: currentDate)
        return formattedDateTime
    }
    
    
    func convertDouble(temp: Double) -> String {
        let temperatureNumber = NSNumber(value: temp)
        var tempString = String(format: "%.0f", temperatureNumber.doubleValue)
        tempString += "º C"
        return tempString
    }
    
    var delegate: WeatherViewInterface?
    
    var weatherService: WeatherServiceInterface? = WeatherService()
    
    var city: City?
    var weatherList: [List] = []
    
    func fetchAllDatas(city: String) {
        weatherService?.fetchAllDatas(city: city, completion: { [weak self] result in
            switch result {
            case .success(let (city, list)):
                self?.city = city
                self?.weatherList = list
                self?.delegate?.didFetchDatas()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

