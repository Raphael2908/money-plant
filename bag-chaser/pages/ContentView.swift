//
//  ContentView.swift
//  bag-chaser
//
//  Created by Raphael Lim on 7/8/23.
//

import SwiftUI

// TODO:
// Display Spending Ui

struct Home: View {
    let LS = Local_Storage_helper()
    let date = Date()
    let dateFormatter = DateFormatter()
    var storage_key: String
    
    @State var today_total_spending: Float
    @State private var isShowingSheet = false

    
    init () {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today_date = dateFormatter.string(from: date)
        storage_key = "spending-\(today_date)"
        _today_total_spending = State(initialValue: LS.load_daily_spending(key: storage_key)?.total ?? 0.0)
    }
    
    var body: some View {
        VStack {
            Text(Date(), style: .date).padding(10)
            Text("Today's Spending")
                .font(.largeTitle)
            Text("$\(today_total_spending, specifier: "%.2f")").font(.title)

            Display_Spending(today_total_spending: $today_total_spending)

            Spacer()
            
            Button(action: {
                isShowingSheet.toggle()
            }, label: {
                Text("Add Spending")
                    .frame(width: 280, height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .cornerRadius(10)
            }).sheet(isPresented: $isShowingSheet) {
                Add_Spending_Card(storage_key: storage_key, today_total_spending: $today_total_spending,isShowingSheet: $isShowingSheet )
            }
            
        }.padding()
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
