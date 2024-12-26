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

enum ReservationResult: String {
    case approve
    case reject
}

enum ReservationStatus: String {
    case KEEP_RESERVATION       // 대기
    case CONFIRM_RESERVATION    // 확정
    case FINISHED_FILM          // 완료
    case CANCEL_RESERVATION     // 거절
}
