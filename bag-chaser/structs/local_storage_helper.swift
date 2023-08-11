//
//  local_storage_helper.swift
//  bag-chaser
//
//  Created by Raphael Lim on 8/8/23.
//

import Foundation

struct Local_Storage_helper{
    
    func save(data: Codable, key: String){
        let encoded = try? JSONEncoder().encode(data)
        UserDefaults.standard.set(try? encoded, forKey: key)
        print("Saved item " + key)
//        print(UserDefaults.standard.dictionaryRepresentation())

    }
    
    func load_daily_spending (key: String) -> Daily_Spending?{
        let data = UserDefaults.standard.object(forKey: key) as? Data
        if (data == nil) {
            return nil
        }
        else {
            let daily_spending: Daily_Spending = try! JSONDecoder().decode(Daily_Spending.self, from: data!)
            return daily_spending
        }
    }
    
    func destroy_spending(key: String, indexSet: IndexSet){
        // Remove a receipt from a daily spending
        let data = UserDefaults.standard.object(forKey: key) as? Data
        var daily_spending: Daily_Spending = try! JSONDecoder().decode(Daily_Spending.self, from: data!)
        
        daily_spending.receipts.remove(atOffsets: indexSet)
        
        save(data: daily_spending, key: key)
        
        print("Removed spending at index: \(daily_spending)")
    }
    
    func edit_spending(key: String, index: Int, new_spending: Spending){
        let data = UserDefaults.standard.object(forKey: key) as? Data
        var daily_spending: Daily_Spending = try! JSONDecoder().decode(Daily_Spending.self, from: data!)
        
        daily_spending.receipts[index] = new_spending
        save(data: daily_spending, key: key)
        print("Updated spending at index \(index) to \(new_spending)")
    }
    
    func destroy_daily_spending(key: String){
        // Remove a receipt from a daily spending
    }
}
