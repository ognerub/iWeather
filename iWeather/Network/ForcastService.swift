import Foundation

final class ForcastService {
    
    static let SearchResultDidChangeNotification = Notification.Name(rawValue: "SearchResultDidChange")
    
    static let shared = ForcastService()
    
    private let urlSession: URLSession
    private let builder: URLRequestBuilder
    
    private var fetchTask: URLSessionTask?
    private var fetchGroupTask: URLSessionTask?
    
    let searchArray: [String] = [
        NetworkConstants.standart.moscow,
        NetworkConstants.standart.saintPetersburg,
        NetworkConstants.standart.novosibirsk,
        NetworkConstants.standart.ekaterinburg,
        NetworkConstants.standart.nizhniyNovgorod,
        NetworkConstants.standart.samara,
        NetworkConstants.standart.omsk,
        NetworkConstants.standart.kazan,
        NetworkConstants.standart.chelyabinsk,
        NetworkConstants.standart.rostovOnDon,
        NetworkConstants.standart.murmansk
    ]
    
    var fetchedArray: [WeatherResponse] = []
    
    init (
        urlSession: URLSession = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.builder = builder
    }
    
    func fetch(searchArray: [String], completion: @escaping (Result<[WeatherResponse], Error>) -> Void) {
        let group = DispatchGroup()
        for searchText in searchArray {
            group.enter()
            guard let request = urlRequestUsing(searchText: searchText) else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
            fetchGroupTask = urlSession.objectTask(for: request) { [weak self] (result: Result<WeatherResponse,Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    self.fetchedArray.append(result)
                    let arrayToReorder = self.createArrayToReorder()
                    let reorderedArray = self.fetchedArray.reorder(by: arrayToReorder)
                    self.fetchedArray = reorderedArray
                    completion(.success(self.fetchedArray))
                case .failure(let error):
                    completion(.failure(error))
                }
                group.leave()
            }
            fetchGroupTask?.resume()
        }
        group.notify(queue: .main) {
            NotificationCenter.default.post(
                name: ForcastService.SearchResultDidChangeNotification,
                object: self,
                userInfo: ["Search": self.fetchedArray]
            )
        }
    }
    
    private func createArrayToReorder() -> [Double] {
        var orderArray: [Double] = []
        searchArray.forEach({
            let separator = ";"
            let stringComponents = $0.components(separatedBy: separator)
            let lat = Double(stringComponents[0])
            orderArray.append(lat ?? 0.0)
        })
        return orderArray
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
