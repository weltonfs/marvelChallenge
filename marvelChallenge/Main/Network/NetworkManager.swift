import Foundation

class Network: AnyObject {
    
    enum NetworkError: Error {
        case noInternet
        case timeout
        case serverError
        // ... other specific error cases
    }
        
    func teste() -> Void{
        // Usage
        fetchCharacters { [weak self] result in
            self.result = result
            
            switch result {
            case .success(let data):
                // Handle success
                print("Data received: \(data)")
                
                guard let characters = try? JSONDecoder().decode(Characters.self, from: data) else {
                    print("Decode error")
                    return
                }
                print(characters)
                
                
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
    
    func fetchCharacters(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let url = URL(string: "https://www.swapi.co/api/films") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Add your headers here, for example:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Replace `YourAccessToken` with your actual access token for the API
            request.setValue("Bearer YourAccessToken", forHTTPHeaderField: "Authorization")
            
            // URLSession configuration
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // Perform URLSession task
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let responseData = data else {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    
                    print("Erro na resposta. Código de status esperado: \(String(describing: response))")
                    return
                }
                
                completion(.success(responseData))
            }
            
            task.resume()
        }
    }
    
    func fetchData2(completionHandler: @escaping ([Characters]) -> Void) {
        if let url = URL(string: "https://www.swapi.co/api/films/") {
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Erro ao obter os filmes: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Erro na resposta. Código de status esperado: \(String(describing: response))")
                    return
                }
            })
            task.resume()
        }
    }
    
}





//func teste() -> Void{
//    // Usage
//    fetchData { [weak self] result in
//        switch result {
//        case .success(let data):
//            // Handle success
//            print("Data received: \(data)")
//        case .failure(let error):
//            // Handle failure
//            print("Error: \(error)")
//        }
//    }
//}
//
//
//func fetchData(completion: @escaping (Result<Data, NetworkError>) -> Void) {
//    guard hasInternetConnection() else {
//        completion(.failure(.noInternet))
//        return
//    }
//
//    // Perform URLSession task
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//        if let error = error {
//            completion(.failure(.serverError))
//            return
//        }
//
//        guard let responseData = data else {
//            completion(.failure(.serverError))
//            return
//        }
//
//        completion(.success(responseData))
//    }
//
//    task.resume()
//}


