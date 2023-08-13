//
//  local_storage_helper_test.swift
//  bag-chaser-tests
//
//  Created by Raphael Lim on 11/8/23.
//

import XCTest

final class local_storage_helper_test: XCTestCase {
    private var local_storage: Local_Storage_helper!
    private var daily_spending: Daily_Spending!
    private var spending: Spending!
    private let storage_key: String = "test-key"

    override func setUpWithError() throws {
        local_storage = Local_Storage_helper()
        spending = Spending(base_amount: 10, service_charge: 0.1, additional_costs: 10, have_gst: true)
        daily_spending = Daily_Spending(receipts: [spending])
    }

    override func tearDownWithError() throws {
        local_storage = nil
        spending = nil
        daily_spending = nil
        UserDefaults.standard.removeObject(forKey: storage_key)
    }

    func test_local_storage_can_save_data() throws {
        local_storage.save(data: daily_spending, key: storage_key)
        XCTAssertNotNil(UserDefaults.standard.object(forKey: storage_key))
    }
    
    func test_local_storage_can_load_data() throws {
        local_storage.save(data: daily_spending, key: storage_key)
        let loaded_daily_spending = local_storage.load_daily_spending(key: storage_key)
        XCTAssertEqual(loaded_daily_spending, daily_spending)
    }
    
    func test_local_storage_can_destroy_spending() throws {
        local_storage.save(data: daily_spending, key: storage_key)
        local_storage.destroy_spending(key: storage_key, index: 0)
        let daily_spending = local_storage.load_daily_spending(key: storage_key)
        XCTAssertTrue(daily_spending?.receipts == [])
    }
    
    func test_local_storage_can_edit_spending() throws {
        local_storage.save(data: daily_spending, key: storage_key)
        let new_spending: Spending = Spending(base_amount: 5, service_charge: 0, additional_costs: 5, have_gst: false)
        local_storage.edit_spending(key: storage_key, index: 0, new_spending: new_spending)
        let test_spending: Spending = (local_storage.load_daily_spending(key: storage_key)?.receipts[0])!
        XCTAssertEqual(new_spending, test_spending)
    }
}
