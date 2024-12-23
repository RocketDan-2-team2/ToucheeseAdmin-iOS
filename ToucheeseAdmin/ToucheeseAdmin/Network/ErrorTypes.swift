//
//  NetworkError.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/23/24.
//

import Foundation

enum ErrorTypes: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(statusCode: Int)
}
