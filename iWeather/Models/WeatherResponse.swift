import Foundation

struct WeatherResponse: Codable {
    let nowDt: String
    let info: Info
    let geoObject: GeoObject
    let yesterday: Yesterday
    let fact: Fact
    let forecasts: [Forecast]
    
    private enum CodingKeys: String, CodingKey {
        case nowDt = "now_dt"
        case info
        case geoObject = "geo_object"
        case yesterday
        case fact
        case forecasts
    }
}

extension WeatherResponse: Reorderable {
    typealias OrderElement = Double
    var orderElement: OrderElement { info.lat }
}

struct Info: Codable {
    let n: Bool
    let geoid: Int
    let url: String
    let lat: Double
    let lon: Double
    let tzinfo: Tzinfo
}

struct Tzinfo: Codable {
    let name: String
    let abbr: String
    let dst: Bool
    let offset: Int
}

struct GeoObject: Codable {
    let district: District
    let locality: Locality
    let province: Province
    let country: Country
}

struct District: Codable {
    let id: Int
    let name: String
}

struct Locality: Codable {
    let id: Int
    let name: String
}

struct Province: Codable {
    let id: Int
    let name: String
}

struct Country: Codable {
    let id: Int
    let name: String
}

struct Yesterday: Codable {
    let temp: Int
}

struct Fact: Codable {
    let temp: Int
    let icon: String
    let condition: String
    let phenomIcon: String?
    let phenomCondition: String?
    
    private enum CodingKeys: String, CodingKey {
        case temp, icon, condition
        case phenomIcon = "phenom_icon"
        case phenomCondition = "phenom_condition"
    }
}

struct Forecast: Codable {
    let date: String
    let parts: Parts
    let hours: [Hour]
}

struct Parts: Codable {
    let day: Day
    let night: Night
}

struct Day: Codable {
    let tempMin: Int?
    let tempAvg: Int?
    let tempMax: Int?
    let icon: String
    let condition: String
}

struct Night: Codable {
    let tempMin: Int?
    let tempAvg: Int?
    let tempMax: Int?
    let icon: String
    let condition: String
}

struct Hour: Codable {
    let hour: String
    let hourTs: Int?
    let temp: Int
    let icon: String
    let condition: String
}

