//
//  EditSpending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation
import SwiftUI

struct Edit_Spending_Card: View {
    @State private var base_amount: Float? = nil
    @State private var gst: Float = 0.08
    @State private var have_service_charge: Bool = true
    @State private var service_charge: Float? = 0.1
    @State private var additional_costs: Float? = nil
    @State private var have_gst: Bool = true
    
    @Environment(\.dismiss) private var dismiss

    
    let spending_index: Int
    let today_spending_storage_key: String
    
    @Binding var today_total_spending: Float
    
    
    init(storage_key: String,
         today_total_spending: Binding<Float>,
         item_index: Int
    ) {
        self.today_spending_storage_key = storage_key
        _today_total_spending = today_total_spending
        
        spending_index = item_index
        let spending: Spending = Local_Storage_helper().load_daily_spending(
            key: storage_key
        )!.receipts[item_index]
    
        _base_amount = State(initialValue: spending.base_amount)
        _have_gst = State(initialValue: spending.have_gst)
        _gst = State(initialValue: spending.gst)
        _additional_costs = State(initialValue: spending.additional_costs)
        
        if(spending.service_charge == 0){
            _have_service_charge = State(initialValue: false)
        }
        _service_charge = State(initialValue: spending.service_charge)
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
                    Toggle("Gst", isOn: $have_gst)
                    Toggle("Service Charge", isOn: $have_service_charge)
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
                    
                    let new_spending: Spending = Spending(
                        base_amount: base_amount!,
                        service_charge: service_charge!,
                        additional_costs: additional_costs!,
                        have_gst: have_gst
                    )

                    Local_Storage_helper().edit_spending(
                        key: today_spending_storage_key,
                        index: spending_index,
                        new_spending: new_spending
                    )
                    
                    today_total_spending = Local_Storage_helper().load_daily_spending(key: today_spending_storage_key)!.total
                    
                    dismiss()
                    
                }, label: {
                    Text("Edit Spending").frame(maxWidth: .infinity).multilineTextAlignment(.center)
                }).disabled(!disableForm)

            }.navigationTitle("Edit Spending")
        }
        
    }
    var disableForm: Bool {
        if(have_service_charge == true){
            return base_amount != nil && service_charge != nil
        }
        return base_amount != nil
    }
}

struct Edit_Spending_Card_Preview: PreviewProvider {
    static var previews: some View {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today_date = dateFormatter.string(from: date)
        let storage_key = "spending-\(today_date)"
        
        return Edit_Spending_Card(
            storage_key: storage_key,
            today_total_spending: .constant(100),
            item_index: 0
        )
    }
}
