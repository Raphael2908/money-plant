//
//  SpendingCard.swift
//  bag-chaser
//
//  Created by Raphael Lim on 10/8/23.
//

import Foundation

import SwiftUI

struct Spending_Card: View {
    @Environment (\.colorScheme) var colorScheme
    var base_amount: Float
    var gst: Float
    var service_charge: Float
    var additional_costs: Float
    var total: Float
    
    init(base_amount: Float, gst: Float, service_charge: Float, additional_costs: Float, total: Float, card_index: Int, storage_key: String,         today_total_spending: Binding<Float>) {
        self.base_amount = base_amount
        self.gst = gst
        self.service_charge = service_charge
        self.additional_costs = additional_costs
        self.total = total
    }
    
    var body: some View {
        
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 3){
                Text("Base Amount: \(base_amount, specifier: "%.2f")").font(.system(size: 18, weight: .light, design: .default))
                Text("Additional Costs: \(additional_costs, specifier: "%.2f")").font(.system(size: 18, weight: .light, design: .default))
                Text("GST: \(gst * 100, specifier: "%.0f")%").font(.system(size: 18, weight: .light, design: .default))
                Text("Service Charge: \(service_charge * 100, specifier: "%.0f")%").font(.system(size: 18, weight: .light, design: .default))
        
                
            }.padding(
                EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0)
            )
            Divider()
            
            Text("Total: $\(total, specifier: "%.2f")")
                .padding(
                    EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 0)
                )
                .font(
                    .system(size: 18, weight: .semibold, design: .rounded)
                )
        }.frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .cornerRadius(5)
        .foregroundColor(Color.theme.text)
      
    }
}

struct Spending_Card_Previews: PreviewProvider {
    static var previews: some View {
        Spending_Card(base_amount: 10, gst: 10, service_charge: 10, additional_costs: 10, total: 10, card_index: 0, storage_key: "", today_total_spending: .constant(1000))
    }
}
