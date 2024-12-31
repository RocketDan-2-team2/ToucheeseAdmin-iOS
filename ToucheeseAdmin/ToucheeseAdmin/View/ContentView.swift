//
//  ContentView.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/6/24.
//

import SwiftUI

struct ContentView: View {
    
    private let network = Network()
    
    @State private var reservationArr: [Reservation] = []
    
    @State private var page = 0
    @State private var isLastPage = false
    
    var body: some View {
        VStack {
            if reservationArr.isEmpty {
                Text("예약 내역이 없습니다.\n네트워크를 확인해보세요.")
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(reservationArr, id:\.self) { reservation in
                            ListCell(order: reservation) { id, result in
                                try await network.handleOrder(id: id, response: result)
                            }
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
            }
        }
        .task { await fetchReservation() }
    }
    
    func fetchReservation() async {
        
        if isLastPage { print("마지막 페이지입니다"); return }
        
        let body = PostBody(page: page, size: 10)
        let reservationResponse = await network.getOrders(body: body)
        
        guard let reservationResponse else { return }
        print(reservationResponse)
        
        reservationArr += reservationResponse.content
        
        // 마지막 페이지라면, 다음 페이지로 이동하지 않음. isLastPage = true
        if reservationResponse.last {
            isLastPage = true
        } else {
            page += 1
        }
    }
}

#Preview {
    ContentView()
}
