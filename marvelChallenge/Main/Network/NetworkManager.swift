import Foundation
import UIKit
import CryptoKit

class NetworkManager: AnyObject {
    
    // MARK: - Private Properties
    
    private let baseUrl = "https://gateway.marvel.com/v1/public/characters"
    private let ts = Date().timeIntervalSince1970.description
    private let apiKey = "e61008c5e7ee9c71437234fdbc1df527"
    private let privateKey = "8511b3bcd071a879eb7de51812d0fd8b74f70965"
    
    // MARK: - Public Properties
    
    enum NetworkError: Error {
        case noInternet
        case timeout
        case serverError
        case emptyData
        case statusCodeError
        case decodeError
    }
    
    // MARK: - Public Methods
    func fetchCharacters(completion: @escaping (Result<Characters, NetworkError>) -> Void) {
        
        guard let url = URL.init(string: getUrl()) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCodeError))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(.emptyData))
                return
            }
            
            do {
                let charactersData = try JSONDecoder().decode(CharactersData.self, from: responseData)
                guard let characters = charactersData.data?.results else {
                    completion(.failure(.emptyData))
                    return
                }
                completion(.success(characters))
            } catch {
                completion(.failure(.decodeError))
                return
            }
        }
        dataTask.resume()
    }
}

private extension NetworkManager {
    
    // MARK: - Private Methods
    
    func getUrl() -> String {
        let hash = MD5(from: ts + privateKey + apiKey)
        let queryItems = queryItems(dictionary: ["ts": ts,
                                                 "apikey": apiKey,
                                                 "hash": hash])
        return baseUrl + queryItems
    }
    
    func MD5(from string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func queryItems(dictionary: [String:Any]) -> String {
        var components = URLComponents()
        components.queryItems = dictionary.map {
            URLQueryItem(name: $0, value: $1  as? String)
        }
        return (components.url?.absoluteString)!
    }
}


