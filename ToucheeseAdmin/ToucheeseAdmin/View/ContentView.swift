//
//  ContentView.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    
    private let network = Network.shared
    
    @State private var reservationArr: [Reservation] = []
    
    @State private var page = 0
    private let size = 10
    @State private var isLastPage = false
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(reservationArr, id:\.self) { reservation in
                    ListCell(order: reservation)
                }
                Rectangle()
                    .fill(.clear)
                    .frame(height: 5.0)
                    .onAppear {
                        if !reservationArr.isEmpty {
                            print("다음 페이지")
                            Task {
                                await fetchReservation()
                            }
                        }
                    }
            }
            .padding()
        }
        .onAppear {
            Task {
                await fetchReservation()
            }
        }
    }
    
    func fetchReservation() async {
        
        if isLastPage { print("마지막 페이지입니다"); return }
        
        do {
            let body = PostBody(page: page, size: size)
            
            let reservationResponse = try await network.getOrders(body: body)
            
            guard let reservationResponse else { return }
            
            print(reservationResponse)
            
            reservationArr += reservationResponse.content
            
            // 마지막 페이지라면, 다음 페이지로 이동하지 않음. isLastPage = true
            if reservationResponse.last {
                isLastPage = true
            } else {
                page += 1
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
