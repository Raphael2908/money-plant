//
//  spending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation

// A class to describe a spending
struct Spending: Codable {
    var base_amount: Float
    var have_gst: Bool = true
    var gst: Float// Gst is in percent
    var service_charge: Float = 0.1 // Service charge is in percent
    var additional_costs: Float
    var total: Float
    
    init(base_amount: Float, service_charge: Float, additional_costs: Float, have_gst: Bool) {
        self.base_amount = base_amount
        self.service_charge = service_charge
        self.additional_costs = additional_costs
        self.have_gst = have_gst
        self.gst = (have_gst == true) ? 0.08 : 0
        self.total = (have_gst == true) ?  (base_amount + additional_costs) * (gst + service_charge + 1)  : (base_amount + additional_costs) * (service_charge + 1)
    }
    
}
