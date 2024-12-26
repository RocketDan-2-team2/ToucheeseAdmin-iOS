//
//  Network.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/20/24.
//

import Foundation

class Network {
    static let shared = Network()
    private let urlSession = URLSession.shared
    private let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
    
    func getOrders() async throws -> ReservationResponse? {
        do {
            let data = try await fetchData(from: baseURLString, body: PostBody.mockData)
            
            return try decodeData(from: data)
        } catch {
            print(error.localizedDescription)
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
            throw ErrorTypes.serverError(statusCode: 0)
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ErrorTypes.serverError(statusCode: response.statusCode)
        }
    }
    
    private func fetchData(from url: String, body: PostBody) async throws -> Data {
        guard let url = URL(string: url) else { throw ErrorTypes.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encodeData(from: body)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ErrorTypes.serverError(statusCode: 0)
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ErrorTypes.serverError(statusCode: response.statusCode)
        }
        
        return data
    }
    
    private func decodeData<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ErrorTypes.decodingError
        }
    }
    
    private func encodeData(from data: PostBody) throws -> Data {
        let encoder = JSONEncoder()
        
        do {
            return try encoder.encode(data)
        } catch {
            throw ErrorTypes.encodingError
        }
    }
}
