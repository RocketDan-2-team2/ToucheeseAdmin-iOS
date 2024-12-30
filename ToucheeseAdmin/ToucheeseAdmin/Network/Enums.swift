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
    case noResponse
    case serverError(Int)
    case unknownError
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            "URL이 잘못 생성되었습니다."
        case .noData:
            "데이터가 없습니다."
        case .decodingError:
            "디코딩 에러가 발생하였습니다."
        case .encodingError:
            "인코딩 에러가 발생하였습니다."
        case .noResponse:
            "응답이 없습니다."
        case .serverError(let statusCode):
            "네트워크 에러 : \(statusCode)"
        case .unknownError:
            "알 수 없는 에러입니다."
        }
    }
}

enum ReservationResult: String {
    case approve
    case reject
    case finish
}

enum ReservationStatus: String {
    case KEEP_RESERVATION       // 대기
    case CONFIRM_RESERVATION    // 확정
    case FINISHED_FILM          // 완료
    case CANCEL_RESERVATION     // 거절
    
    var description: String {
        switch self {
        case .FINISHED_FILM:
            "촬영을 완료하였습니다."
        case ReservationStatus.CANCEL_RESERVATION:
            "예약이 취소되었습니다."
        case ReservationStatus.CONFIRM_RESERVATION:
            "예약이 확정되었습니다."
        default :
            "default"
        }
    }
}
