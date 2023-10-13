//
//  TranslateService.swift
//  ReadForU
//
//  Created by Serena on 2023/10/14.
//

import Foundation

struct TranslateService {
    var result = ""
    
    func postRequset(source: String, target: String, text: String) {
        guard let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt") else { return }
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: true)
        component?.queryItems = [URLQueryItem(name: "source", value: source),
                                 URLQueryItem(name: "target", value: target),
                                 URLQueryItem(name: "text", value: text)]
        
        var request = URLRequest(url: component?.url ?? url,
                                 timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("1iStJeyJ4Dv8lN5IlKZL", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("54w46hOuyk", forHTTPHeaderField: "X-Naver-Client-Secret")
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
//            fetchData(data: data)
        }
        task.resume()
    }
    
    private func fetchData(data: PapagoTranslate) {
        
    }
}
