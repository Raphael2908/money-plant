//
//  DisplaySpending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation

import SwiftUI

extension Int: Identifiable {
    public var id: Int { return self }
}

struct Display_Spending: View {
    let LS = Local_Storage_helper()
    let date = Date()
    let dateFormatter = DateFormatter()
    var storage_key: String
    
    @State private var IsShowingEditSheet: Bool = false
    @State var card_index: Int? = nil
    
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
                Spending_Card(
                    base_amount: spendings[spending_index].base_amount,
                    gst: spendings[spending_index].gst,
                    service_charge: spendings[spending_index].service_charge,
                    additional_costs: spendings[spending_index].additional_costs,
                    total: spendings[spending_index].total,
                    
                    card_index: spending_index,
                    storage_key: storage_key,
                    today_total_spending: $today_total_spending
                ).onTapGesture {
                    IsShowingEditSheet = true
                    card_index = spending_index
                    
                }.padding(5)
           }.onDelete { indexSet in
               if indexSet.first == nil {
                   // Throw error
               }
               LS.destroy_spending(key: storage_key, index: indexSet.first!)
               today_total_spending = LS.load_daily_spending(key: storage_key)!.total
            }
            .listRowInsets(EdgeInsets())// Removes list padding
            .listRowSeparator(.hidden)
            .shadow(radius: 5, x: 0, y: 4)
            .sheet(isPresented: $IsShowingEditSheet, onDismiss: {IsShowingEditSheet = false}) {
                Edit_Spending_Card(
                    storage_key: storage_key,
                    today_total_spending: $today_total_spending,
                    item_index: self.card_index ?? 0
                ).presentationDetents([.medium])
            }
            
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)

    }
}

struct Display_Spending_Previews: PreviewProvider {
    static var previews: some View {
        Display_Spending( today_total_spending: .constant(10))
    }
}
