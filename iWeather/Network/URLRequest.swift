import Foundation

final class URLRequestBuilder {
    static let shared = URLRequestBuilder()
    
    func makeSearchHTTPRequest (
        path: String,
        httpMethod: String,
        baseURLString: String,
        searchText: String?) -> URLRequest?
    {
        let simpleRequest = makeBaseRequestAndURL(
            path: path,
            httpMethod: httpMethod,
            baseURLString: baseURLString)
        var request: URLRequest = simpleRequest.0
        let baseURL: URL = simpleRequest.1
        
        guard let searchText = searchText else { return nil }
        let separator = ";"
        let stringComponents = searchText.components(separatedBy: separator)
        let lat = stringComponents[0]
        let lon = stringComponents[1]
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "lang", value: "ru_RU"),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "hours", value: "true"),
            URLQueryItem(name: "extra", value: "false"),
        ]
        guard let comurl = components?.url else {
            print("error to create url")
            return nil
        }
        
        request.setValue(NetworkConstants.standart.personalToken, forHTTPHeaderField: "X-Yandex-API-Key")
        
        request.url = comurl
        return request
    }
    
    private func makeBaseRequestAndURL(
        path: String,
        httpMethod: String,
        baseURLString: String
    ) -> (URLRequest, URL) {
        let emptyURL = URL(fileURLWithPath: "")
        guard
            baseURLString.isValidURL,
            let url = URL(string: baseURLString),
            let baseURL = URL(string: path, relativeTo: url)
        else {
            assertionFailure("Impossible to create URLRequest of URL")
            return (URLRequest(url: emptyURL), emptyURL)
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = httpMethod
        request.timeoutInterval = 5
        return (request, baseURL)
    }
    
}
