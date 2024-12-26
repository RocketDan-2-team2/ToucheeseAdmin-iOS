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
    @State private var page: Int = 0
    
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
                        }
                    }
            }
            .padding()
        }
        .onAppear {
            Task {
                do {
                    if let firstData = try await network.getOrders() {
                        reservationArr.append(contentsOf: firstData.content)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
