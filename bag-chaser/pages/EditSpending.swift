//
//  EditSpending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation
import SwiftUI

struct Edit_Spending_Card: View {
    @State private var base_amount: Float
    @State private var gst: Float
    @State private var service_charge: Float
    @State private var additional_costs: Float
    @State private var have_gst: Bool = true
    let spending_index: Int
    
    let today_spending_storage_key: String
    @Binding var today_total_spending: Float
    
    init(storage_key: String, today_total_spending: Binding<Float>, item_index: Int) {
        self.today_spending_storage_key = storage_key
        self.spending_index = item_index
        _today_total_spending = today_total_spending
        let spending: Spending = Local_Storage_helper().load_daily_spending(key: storage_key)!.receipts[item_index]
        self.base_amount = spending.base_amount
        self.gst = spending.gst
        self.service_charge = spending.service_charge
        self.additional_costs = spending.additional_costs
    }
    
    var body: some View{
        
        VStack{
            
                TextField(
                    "Base Amount",
                    value: $base_amount,
                    format: .number
                )
                
                TextField(
                      "gst",
                      value: $gst,
                      format: .number
                ).keyboardType(.numberPad)
                TextField(
                      "service_charge",
                      value: $service_charge,
                      format: .number
                ).keyboardType(.numberPad)
                TextField(
                      "additional_costs",
                      value: $additional_costs,
                      format: .number
                ).keyboardType(.numberPad)
                
                Button("Edit Spending"){
                    let new_spending: Spending = Spending(base_amount: base_amount, service_charge: service_charge, additional_costs: additional_costs, have_gst: have_gst)
                    Local_Storage_helper().edit_spending(key: today_spending_storage_key, index: spending_index, new_spending: new_spending)
                    today_total_spending = Local_Storage_helper().load_daily_spending(key: today_spending_storage_key)!.total
                }
            
        }
        .cornerRadius(10)
        .shadow(radius: 5, x: 2, y: 5)
    }
}
