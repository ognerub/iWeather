import Foundation

final class ForcastService {
    
    static let SearchResultDidChangeNotification = Notification.Name(rawValue: "SearchResultDidChange")
    
    static let shared = ForcastService()
    
    private let urlSession: URLSession
    private let builder: URLRequestBuilder
    
    private var fetchTask: URLSessionTask?
    private var fetchGroupTask: URLSessionTask?
    private (set) var found: WeatherResponse?
    
    init (
        urlSession: URLSession = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.builder = builder
    }
    
    func fetch(searchText: String?, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let searchText = searchText else { return }
        if fetchTask != nil { return } else { fetchTask?.cancel() }
        guard let request = urlRequestUsing(searchText: searchText) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        fetchTask = urlSession.objectTask(for: request) { [weak self] (result: Result<WeatherResponse,Error>) in
            guard let self = self else { return }
            self.fetchTask = nil
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
        }
        fetchTask?.resume()
    }
    
    func fetch(group: DispatchGroup, searchText: String?, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let searchText = searchText else { return }
        group.enter()
        guard let request = urlRequestUsing(searchText: searchText) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        fetchGroupTask = urlSession.objectTask(for: request) { [weak self] (result: Result<WeatherResponse,Error>) in
            guard let self = self else { return }
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
        fetchGroupTask?.resume()
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
