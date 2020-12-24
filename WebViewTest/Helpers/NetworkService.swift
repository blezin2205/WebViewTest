//
//  NetworkService.swift
//  WebViewTest
//
//  Created by Blezin on 23.12.2020.
//  Copyright © 2020 Blezin'sDev. All rights reserved.
//

import Foundation

class NetworkService {
    
    func getListA(pathA: String, response: @escaping (Result<[AResponse], Error>) -> Void) {
        request(path: pathA) { (data, error) in
            if let error = error {
                response(.failure(error))
            }
            let decode = self.decodeJSON(type: [AResponse].self, from: data)
            if let arrayA = decode {
                response(.success(arrayA))
            }
        }
    }
    
    func getListB(pathB: String, response: @escaping (Result<BResponse, Error>) -> Void) {
        request(path: pathB) { (data, error) in
            if let error = error {
                response(.failure(error))
            }
            let decode = self.decodeJSON(type: BResponse.self, from: data)
            if let arrayB = decode {
                response(.success(arrayB))
            }
        }
    }
    
    private func request(path: String?, completion: @escaping (Data?, Error?) -> Void) {
        guard let path = path, let url = URL(string: path) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
