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
    
    @AppStorage("notWelcomed") var showWelcomeScreen: Bool = true
    @State var today_total_spending: Float
    @State private var isShowingSheet = false

    
    init () {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today_date = dateFormatter.string(from: date)
        storage_key = "spending-\(today_date)"
        _today_total_spending = State(initialValue: LS.load_daily_spending(key: storage_key)?.total ?? 0.0)
    }
    
    var body: some View {
        
        NavigationStack{
            VStack {
                Text(Date(), style: .date)
                    .padding(10)
                    .foregroundColor(Color.theme.text)
                Text("Today's Spending")
                    .foregroundColor(Color.theme.text)
                    .font(.largeTitle)
                Text("$\(today_total_spending, specifier: "%.2f")")
                    .font(.title)
                    .foregroundColor(Color.theme.text)

                Divider()
                
                Display_Spending(today_total_spending: $today_total_spending)

                Button(action: {
                    isShowingSheet.toggle()
                }, label: {
                    Text("Add Spending")
                        .frame(width: 280, height: 50)
                        .background(Color.theme.accent)
                        .foregroundColor(Color.theme.buttonText)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .cornerRadius(10)
                }).sheet(isPresented: $isShowingSheet) {
                    Add_Spending_Card(storage_key: storage_key, today_total_spending: $today_total_spending,isShowingSheet: $isShowingSheet )
                }
            }
            .background(Color.theme.background)
            .fullScreenCover(isPresented: $showWelcomeScreen, content: {
                Welcome(showWelcomeScreen: $showWelcomeScreen)
            })
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
