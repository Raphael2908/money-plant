//
//  daily_spending.swift
//  bag-chaser
//
//  Created by Raphael Lim on 9/8/23.
//

import Foundation

struct Daily_Spending: Codable, Equatable{
    static func == (lhs: Daily_Spending, rhs: Daily_Spending) -> Bool {
        return lhs.receipts == rhs.receipts && lhs.total == rhs.total
    }
    
    var receipts: Array<Spending>
    var total: Float {
        return receipts.reduce(0, {$0 + $1.total})
    }
    
    init(receipts: Array<Spending>) {
        self.receipts = receipts
    }
}
