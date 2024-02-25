import Foundation

final class ForcastService {
    
    static let SearchResultDidChangeNotification = Notification.Name(rawValue: "SearchResultDidChange")
    
    static let shared = ForcastService()
    
    private let urlSession: URLSession
    private let builder: URLRequestBuilder
    
    private var currentTask: URLSessionTask?
    private (set) var found: WeatherResponse = WeatherResponse(
        nowDt: "",
        info: Info(
            n: false,
            geoid: 0,
            url: "",
            lat: 0.0,
            lon: 0.0,
            tzinfo: Tzinfo(
                name: "",
                abbr: "",
                dst: false,
                offset: 0)),
        geoObject: GeoObject(
            district: District(id: 0, name: ""),
            locality: Locality(id: 0, name: ""),
            province: Province(id: 0, name: ""),
            country: Country(id: 0, name: "")),
        yesterday: Yesterday(temp: 0),
        fact: Fact(temp: 0, icon: "", condition: "", phenomIcon: "", phenomCondition: ""),
        forecasts: [
            Forecast(
                date: "",
                parts: Parts(
                    day: Day(
                        tempMin: 0,
                        tempAvg: 0,
                        tempMax: 0,
                        icon: "",
                        condition: ""
                    ), night: Night(
                        tempMin: 0,
                        tempAvg: 0,
                        tempMax: 0,
                        icon: "",
                        condition: "")),
                hours: [
                    Hour(
                        hour: "",
                        hourTs: 0,
                        temp: 0,
                        icon: "",
                        condition: "")
                ])
        ])
    
    init (
        urlSession: URLSession = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.builder = builder
    }
    
    func fetchPhotosUsing(searchText: String?, group: DispatchGroup, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let searchText = searchText else { return }
        //if currentTask != nil { return } else { currentTask?.cancel() }
        
        group.enter()
        
        guard let request = urlRequestUsing(searchText: searchText) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        currentTask = urlSession.objectTask(for: request) { [weak self] (result: Result<WeatherResponse,Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentTask = nil
                switch result {
                case .success(let result):
                    self.found = result
                    NotificationCenter.default.post(
                        name: ForcastService.SearchResultDidChangeNotification,
                        object: self,
                        userInfo: ["Search": result]
                    )
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
        }
        currentTask?.resume()
    }
}

private extension ForcastService {
    func urlRequestUsing(searchText: String?) -> URLRequest? {
        guard let searchText = searchText else { return nil}
        let path: String = "/v2/forecast?"
        return builder.makeSearchHTTPRequest(
            path: path,
            httpMethod: "GET",
            baseURLString: NetworkConstants.standart.baseURL,
            searchText: "\(searchText)"
        )
    }
}
