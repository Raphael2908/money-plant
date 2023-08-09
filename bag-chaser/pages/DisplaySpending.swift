//
//  DisplaySpending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation

import SwiftUI

struct Spending_Card: View {
    var body: some View {
        Text("Spending Card")
    }
}

extension Int: Identifiable {
    public var id: Int { return self }
}

struct Display_Spending: View {
    let LS = Local_Storage_helper()
    let date = Date()
    let dateFormatter = DateFormatter()
    var storage_key: String
    
    @State private var selectedSpending: Int? = nil
    @Binding var today_total_spending: Float // Sync's total spending with Home view
    
    init (today_total_spending: Binding<Float>) {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today_date = dateFormatter.string(from: date)
        storage_key = "spending-\(today_date)"
        _today_total_spending = today_total_spending
    }
    
    var body: some View {
        let spendings: Array = LS.load_daily_spending(key: storage_key)!.receipts
        List{
            ForEach(spendings.indices, id: \.self) { spending_index in
                HStack{
                    VStack{
                            Text("Base Amount: \(spendings[spending_index].base_amount, specifier: "%.2f")")
                            Text("Gst: \(spendings[spending_index].gst * 100, specifier: "%.0f")%")
                            Text("Service Charge: \(spendings[spending_index].service_charge * 100, specifier: "%.0f")%")
                            Text("Additional Costs: \(spendings[spending_index].additional_costs, specifier: "%.2f")")
                            Text("Total: \(spendings[spending_index].total, specifier: "%.2f")").padding(10)
                    }
                    Button(action: {
                        self.selectedSpending = spending_index
                    
                    }, label: {
                        Text("Edit")
                    }).sheet(item: self.$selectedSpending) {_ in
                        Edit_Spending_Card(storage_key: storage_key, today_total_spending: $today_total_spending, item_index: self.selectedSpending ?? 0)
                    }
                }
           }
            .onDelete { indexSet in
                LS.destroy_spending(key: storage_key, indexSet: indexSet)
                today_total_spending = LS.load_daily_spending(key: storage_key)!.total
            }
     
        }.scrollContentBackground(.hidden)
           


    }
}

struct Display_Spending_Previews: PreviewProvider {
    static var previews: some View {
        Display_Spending( today_total_spending: .constant(10))
    }
}
