import Foundation

extension URLSession {
    
    func objectTask<T: Codable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fullFillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        //decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fullFillCompletionOnMainThread(.success(result))
                    } catch {
                        fullFillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    print("Error encoding \(String(data: data, encoding: .utf8) ?? "Error data encoding while getting statusCode")")
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fullFillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fullFillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
