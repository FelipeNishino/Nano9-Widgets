//
//  HTTPRequest.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custon(errorMessage: String)
}

enum RequestError: Error {
    case emptyData
    case urlErro
    case custon(errorMessage: String)
}

struct HTTPRequest {
    var token: AuthManager = AuthManager.shared
    
    var header: [String: String] { [
        "Client-ID" : token.clientID,
        "Authorization" : token.autorization,
        "Accept": "application/json"
        ]
    }
    
    func refreshToken( completion: @escaping (Result<LoginReponse, Error>) -> Void) {
        
        let parameters: [String:String] = ["client_id": token.clientID, "client_secret": token.clientSecret, "grant_type": token.grantType]

        request(IGDBRoutes.Login()
                    .post(parameters: parameters), genericType: LoginReponse.self, header: nil) { result, response in
            switch result {
            case .success(let result):
                AuthManager.shared.loginResponse = result
                completion(.success(result))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request<T: Codable>(_ routable: Routable, genericType: T.Type, completion: @escaping (Result<T, Error>, URLResponse?) -> Void){
        if token.isAuthentication {
            request(routable, genericType: genericType, header: header, completion: completion)
        } else {
            refreshToken { result in
                switch result {
                case .success(_):
                    request(routable, genericType: genericType, header: header, completion: completion)
                case .failure(let error):
                    completion(.failure(error), nil)
                }
            }
        }
    }
    
    private func request<T: Codable>(_ routable: Routable, genericType: T.Type, header: [String: String]?, completion: @escaping (Result<T, Error>, URLResponse?) -> Void){
        
        guard var urlComponents = URLComponents(string: routable.route) else {
            completion(.failure(RequestError.urlErro), nil)
            return
        }
        
        if let parameters = routable.parameters {
            urlComponents.queryItems = parameters.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = routable.method
        urlRequest.httpBody = routable.body.data(using: .utf8, allowLossyConversion: false)
        if let header = header {
            header.forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        request(T.self, request: urlRequest) { result, response in
            completion(result,response)
        }
        
    }
    
    private func request<T: Codable>(_ genericType: T.Type,request: URLRequest, completion: @escaping (Result<(T), Error>, URLResponse?) -> Void){
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(RequestError.emptyData), response)
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(RequestError.custon(errorMessage: "JSON Seriarilinz error")), response)
                debugPrint("Data : \(String(decoding: data, as: UTF8.self))")
                return
            }
            completion(.success(result), response)
        }.resume()
    }
}

