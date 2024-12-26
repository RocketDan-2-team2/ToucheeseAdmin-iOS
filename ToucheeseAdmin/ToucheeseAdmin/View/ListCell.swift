//
//  ListCell.swift
//  ToucheeseAdmin
//
//  Created by woong on 12/23/24.
//

import SwiftUI

struct ListCell: View {
    let order: Reservation
    
    private var studioImage: String
    private var studioName: String
    private var orderDate: String // Date extension으로 추가해주기
    private var userName: String
    private var itemName: String
    private var itemPrice: Int
    private var totalPrice: Int = 0
    
    init(order: Reservation) {
        self.order = order
        self.studioImage = order.studioProfile
        self.studioName = order.studioName
        self.orderDate = order.orderDate
        self.userName = order.userName
        self.itemName = order.orderItems[0].itemName
        self.itemPrice = order.orderItems[0].itemPrice
        
        for option in order.orderItems[0].orderOptions {
            self.totalPrice += option.optionPrice * option.optionQuantity
        }
        self.totalPrice += itemPrice
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                let imageURL = URL(string: studioImage)
                
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        }
                        
                } placeholder: {
                    ProgressView()
                        .aspectRatio(contentMode: .fill)
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 60, height: 60)
                        }
                        
                }
                .clipShape(
                    Circle()
                )
                .frame(width: 60, height: 60)
                .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text(studioName)
                        .padding(.bottom, 1)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(orderDate.substring(from: 0, to: 9))
                    }
                }
                Spacer()
            }
            .padding(.vertical)
            .background (
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, topTrailing: 10))
                    .fill(Color.primary02)
            )
            
            VStack(alignment: .leading) {
                HTwoText(first: "예약자명", second: userName)
                
                Text(itemName)
                    .font(.system(size: 20))
                    .padding(.bottom, 3)
                
                HTwoText(first: "가격", second: "\(itemPrice)원")
                
                if order.orderItems[0].orderOptions.count != 0 {
                    Text("추가 금액")
                        .font(.system(size: 20))
                        .padding(.bottom, 3)
                    
                    ForEach(order.orderItems[0].orderOptions, id:\.self) { item in
                        HStack {
                            HTwoText(first: item.optionName, second: "\(item.optionPrice)원")
                            Image(systemName: "xmark")
                            Text("\(item.optionQuantity)")
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Text("총 금액")
                        .font(.system(size: 25))
                    Spacer()
                    Text("\(totalPrice)")
                }
                .padding(.vertical, 3)
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("예약 실패")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.primary)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.primary02)
                    
                    
                    Button {
                        
                    } label: {
                        Text("예약 성공")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.primary)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.primary02)
                    
                    
                    
                }
            }
            .padding()
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 10, bottomTrailing: 10))
                    .fill(Color.primary01)
            }
        }
        
    }
}

struct HTwoText: View {
    let first: String
    let second: String
    
    var body: some View {
        HStack {
            Text(first)
                .font(.system(size: 17))
            
            Spacer()
            
            Text(second)
                .font(.system(size: 17))
        }
        .padding(.bottom, 3)
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
}

#Preview {
    ListCell(order: Reservation.reservationFirstItem)
}
