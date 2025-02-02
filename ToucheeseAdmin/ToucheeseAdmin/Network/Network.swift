//
//  Network.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/20/24.
//

import Foundation

class Network {

    private let urlSession: URLSession
    private let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300
        self.urlSession = URLSession(configuration: configuration)
    }
    
    func getOrders(body: PostBody) async -> ReservationResponse? {
        do {
            let data = try await fetchData(from: baseURLString, body: body)
            
            let response = try decodeData(from: data)
            
            print("Current Page: \(response.number)")
            print("Total Pages: \(response.totalPages)")
            print("Is Last Page: \(response.last)")
            
            return try decodeData(from: data)
        } catch let error as ErrorTypes {
            print(error.errorMessage)
        } catch {
            print("알 수 없는 에러입니다. : ", error)
        }
        return nil
    }
    
    func handleOrder(id: Int, response: ReservationResult) async throws {
        let orderId = "/\(id)"
        let fullURL = baseURLString + orderId + "/\(response.rawValue)"
        guard let url = URL(string: fullURL) else { throw ErrorTypes.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ErrorTypes.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            print("주문 처리가 성공적으로 반영되었습니다.")
        case 400...499:
            throw ErrorTypes.serverError(response.statusCode)
        case 500...599:
            throw ErrorTypes.serverError(response.statusCode)
        default :
            throw ErrorTypes.unknownError
        }
    }
    
    private func fetchData(from url: String, body: PostBody) async throws -> Data {
        guard let url = URL(string: url) else { throw ErrorTypes.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encodeData(from: body)
        
        print("Request URL: \(url)")
        print("Request Body: \(String(data: request.httpBody!, encoding: .utf8) ?? "")")
        
        let (data, response) = try await urlSession.data(for: request)
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw ErrorTypes.noResponse
        }
        
        switch response.statusCode {
        case 200...299:
            return data
        case 400...499:
            throw ErrorTypes.serverError(response.statusCode)
        case 500...599:
            throw ErrorTypes.serverError(response.statusCode)
        default :
            throw ErrorTypes.unknownError
        }
    }
    
    private func decodeData(from data: Data) throws -> ReservationResponse {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(ReservationResponse.self, from: data)
        } catch {
            throw ErrorTypes.decodingError
        }
    }
    
    private func encodeData(from data: Encodable) throws -> Data {
        let encoder = JSONEncoder()
        
        do {
            return try encoder.encode(data)
        } catch {
            throw ErrorTypes.encodingError
        }
    }
}
