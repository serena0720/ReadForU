//
//  Bundle+.swift
//  ReadForU
//
//  Created by Serena on 2023/10/17.
//

import Foundation

extension Bundle {
    var papagoApiKeyId: String {
        guard let file = self.path(forResource: "PapagoAPIKey", ofType: "plist") else { return "" }

        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let id = resource["Id"] as? String else {
            fatalError("KakaoAPIKey.plist에 Id를 설정해주세요.")
        }
        
        return id
    }
    
    var papagoApiKeySecret: String {
        guard let file = self.path(forResource: "PapagoAPIKey", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let secret = resource["Secret"] as? String else {
            fatalError("KakaoAPIKey.plist에 Secret를 설정해주세요.")
        }
        
        return secret
    }
}
