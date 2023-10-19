//
//  APIError.swift
//  ReadForU
//
//  Created by Serena on 2023/10/17.
//

import Foundation

enum APIError: LocalizedError {
    case cannotLoadFromNetwork
    case failureHttpResponse
    case unknown
}
