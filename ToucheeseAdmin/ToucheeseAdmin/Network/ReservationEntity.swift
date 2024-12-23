//
//  ReservationEntity.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/20/24.
//

import Foundation

// MARK: - Main Response
struct ReservationResponse: Decodable {
    let content: [Reservation]
    let pageable: Pageable
    let last: Bool
    let totalPages: Int
    let totalElements: Int
    let first: Bool
    let size: Int
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let empty: Bool
    
    static let mockData: ReservationResponse = ReservationResponse(content: [Reservation.reservationFirstItem, Reservation.reservationThirdItem, Reservation.reservationSecondItem], pageable: Pageable.mockData, last: true, totalPages: 1, totalElements: 3, first: true, size: 3, number: 3, sort: Sort.mockData, numberOfElements: 3, empty: false)
}

// MARK: - Reservation
struct Reservation: Decodable {
    let orderId: Int
    let studioProfile: String
    let studioName: String
    let orderDate: String // ISO8601 형식의 문자열로 처리
    let userName: String
    let orderItems: [OrderItem]
    
    enum CodingKeys: String, CodingKey {
        case orderId, studioProfile, studioName, userName, orderItems
        case orderDate = "orderDateTime"
    }
    
    static let studioProfileImage = "https://i.imgur.com/lB7gB4f.jpeg"
    static let orderDateTime = "2024-12-06T23:51"
    
    static let reservationFirstItem: Reservation = Reservation(orderId: 1, studioProfile: studioProfileImage, studioName: "미미", orderDate: orderDateTime, userName: "이선준", orderItems: [OrderItem.firstOrder])
    
    static let reservationSecondItem: Reservation = Reservation(orderId: 2, studioProfile: studioProfileImage, studioName: "시현하다", orderDate: orderDateTime, userName: "김철수", orderItems: [OrderItem.secondOrder, OrderItem.thirdOrder])
    
    static let reservationThirdItem: Reservation = Reservation(orderId: 3, studioProfile: studioProfileImage, studioName: "흑백사진관", orderDate: orderDateTime, userName: "김영희", orderItems: [OrderItem.fourthOrder, OrderItem.secondOrder])
}

// MARK: - Order Item
struct OrderItem: Decodable {
    let itemId: Int
    let itemName: String
    let itemPrice: Int // 상품 단일 가격
    let itemQuantity: Int
    let orderOptions: [OrderOption]
    
    enum CodingKeys: String, CodingKey {
        case itemId, itemName, itemPrice, itemQuantity
        case orderOptions = "adminOrderOptions"
    }
    
    static let firstOrder = OrderItem(itemId: 0, itemName: "프로필 사진", itemPrice: 80000, itemQuantity: 1, orderOptions: [OrderOption.firstOption, OrderOption.secondOption])
    static let secondOrder = OrderItem(itemId: 1, itemName: "바디 프로필", itemPrice: 20000, itemQuantity: 1, orderOptions: [OrderOption.firstOption, OrderOption.secondOption, OrderOption.thirdOption, OrderOption.fifthOption])
    static let thirdOrder = OrderItem(itemId: 2, itemName: "컨셉 사진", itemPrice: 12000, itemQuantity: 1, orderOptions: [OrderOption.firstOption, OrderOption.secondOption, OrderOption.thirdOption])
    static let fourthOrder = OrderItem(itemId: 3, itemName: "증명 사진", itemPrice: 40000, itemQuantity: 1, orderOptions: [OrderOption.secondOption, OrderOption.secondOption])
    
}

// MARK: - Admin Order Option
struct OrderOption: Decodable {
    let optionId: Int
    let optionName: String
    let optionPrice: Int // 옵션 단일 가격
    let optionQuantity: Int
    
    static let firstOption = OrderOption(optionId: 0, optionName: "보정", optionPrice: 10000, optionQuantity: 1)
    static let secondOption = OrderOption(optionId: 1, optionName: "인화", optionPrice: 5000, optionQuantity: 2)
    static let thirdOption = OrderOption(optionId: 2, optionName: "기본액자", optionPrice: 10000, optionQuantity: 2)
    static let fourthOption = OrderOption(optionId: 3, optionName: "인화", optionPrice: 5000, optionQuantity: 4)
    static let fifthOption = OrderOption(optionId: 4, optionName: "고급액자", optionPrice: 20000, optionQuantity: 4)
}

// MARK: - Pageable Information
struct Pageable: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let sort: Sort
    let offset: Int
    let unpaged, paged: Bool
    
    static let mockData = Pageable(pageNumber: 0, pageSize: 10, sort: Sort.mockData, offset: 0, unpaged: false, paged: true)
    
    /*
     "pageable": {
             "pageNumber": 0,
             "pageSize": 10,
             "sort": {
                 "empty": true,
                 "unsorted": true,
                 "sorted": false
             },
             "offset": 0,
             "unpaged": false,
             "paged": true
         },
     */
}

// MARK: - Sort Information
struct Sort: Decodable {
    let empty, unsorted, sorted: Bool
    
    static let mockData = Sort(empty: false, unsorted: true, sorted: false)
}
