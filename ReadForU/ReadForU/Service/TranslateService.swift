//
//  TranslateService.swift
//  ReadForU
//
//  Created by Serena on 2023/10/14.
//

import Foundation

struct TranslateService {
    func postPapagoRequest(source: String, target: String, text: String, completion: @escaping (Result<PapagoTranslate, APIError>) -> Void) {
        var component = URLComponents()
        component.scheme = PapagoComponentNameSpace.scheme
        component.host = PapagoComponentNameSpace.host
        component.path = PapagoComponentNameSpace.translatePath
        component.queryItems = [
            URLQueryItem(name: PapagoComponentNameSpace.source, value: source),
            URLQueryItem(name: PapagoComponentNameSpace.target, value: target),
            URLQueryItem(name: PapagoComponentNameSpace.text, value: text)
        ]
        
        guard let papagoURL = component.url else { return }
        
        var request = URLRequest(url: papagoURL, timeoutInterval: Double.infinity)
        request.addValue(PapagoNameSpace.contentTypeValue, forHTTPHeaderField: PapagoNameSpace.contentType)
        request.addValue(Bundle.main.papagoApiKeyId, forHTTPHeaderField: PapagoNameSpace.clientId)
        request.addValue(Bundle.main.papagoApiKeySecret, forHTTPHeaderField: PapagoNameSpace.clientSecret)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(APIError.cannotLoadFromNetwork))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.failureHttpResponse))
                return
            }

            if let data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    let translateResult = try jsonDecoder.decode(PapagoTranslate.self, from: data)
                    completion(.success(translateResult))
                } catch {
                    completion(.failure(APIError.unknown))
                }
            }
        }.resume()
    }
}
