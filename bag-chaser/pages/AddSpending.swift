//
//  AddSpending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation
import SwiftUI

struct Add_Spending_Card: View {
    @State private var base_amount: Float? = nil
    @State private var gst: Float = 0.08
    @State private var have_service_charge: Bool = true
    @State private var service_charge: Float? = 0.1
    @State private var additional_costs: Float? = nil
    @State private var have_gst: Bool = true
  
    
    let today_spending_storage_key: String
    @Binding var today_total_spending: Float
    @Binding var isShowingSheet: Bool
    
    init(storage_key: String, today_total_spending: Binding<Float>, isShowingSheet: Binding<Bool>) {
        self.today_spending_storage_key = storage_key
        _today_total_spending = today_total_spending
        _isShowingSheet = isShowingSheet
    }
    
    var body: some View{
        

        NavigationStack{
            Form{
                Section{
                    TextField(
                        "Base Amount",
                        value: $base_amount,
                        format: .number,
                        prompt: Text("Amount")
                    ).keyboardType(.decimalPad)
                    
                    TextField(
                        "Additional Costs",
                        value: $additional_costs,
                        format: .number
                    ).keyboardType(.decimalPad)
                }
                
                Section{
                    Toggle("Gst", isOn: $have_gst).tint(Color.theme.accent)
                    Toggle("Service Charge", isOn: $have_service_charge).tint(Color.theme.accent)
                    if(have_service_charge){
                        TextField(
                            "Service Charge",
                            value: $service_charge,
                            format: .percent.precision(.significantDigits(2))
                        ).keyboardType(.decimalPad)
                    }
                }
                Button(action: {
                    if(have_service_charge == false){
                        service_charge = 0
                    }
                    if(have_gst == false){
                        gst = 0
                    }
                    if(additional_costs == nil){
                        additional_costs = 0
                    }
                    
                    let spent: Spending = Spending(
                        base_amount: base_amount!,
                        service_charge: service_charge!,
                        additional_costs: additional_costs!,
                        have_gst: have_gst
                    )
                    var daily_spending = Local_Storage_helper().load_daily_spending(key: today_spending_storage_key)
                    
                    daily_spending?.receipts.append(spent)
                    today_total_spending = daily_spending?.total ?? 0
                    
                    Local_Storage_helper().save(
                        data: daily_spending,
                        key: today_spending_storage_key
                    )
                    
                    isShowingSheet = false
                }, label: {
                    Text("Add Spending").frame(maxWidth: .infinity).multilineTextAlignment(.center)
                }).disabled(!disableForm)

            }.navigationTitle("New Spending")
        }.background(Color.theme.background)
    }
    var disableForm: Bool {
        if(have_service_charge == true){
            return base_amount != nil && service_charge != nil
        }
        return base_amount != nil
    }
}

struct Add_Spending_Card_Previews: PreviewProvider {
    static var previews: some View {
        Add_Spending_Card(storage_key: "", today_total_spending: .constant(10), isShowingSheet: .constant(true))
    }
}
