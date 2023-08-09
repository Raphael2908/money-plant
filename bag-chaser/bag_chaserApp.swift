//
//  bag_chaserApp.swift
//  bag-chaser
//
//  Created by Raphael Lim on 7/8/23.
//

import SwiftUI



@main
struct bag_chaserApp: App {
    
    init() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let today_date = dateFormatter.string(from: date)
        let storage_key: String = "spending-\(today_date)"

        let LS = Local_Storage_helper()
        // Checks if there is a daily spending for today
        if (LS.load_daily_spending(key: storage_key) == nil) {
            // If no, creates a new daily spending, stores in local storage, pass data into home
            let Today_Spending = Daily_Spending(receipts: [])
            LS.save(data: Today_Spending, key: storage_key)
            
        }
     }
    
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}
