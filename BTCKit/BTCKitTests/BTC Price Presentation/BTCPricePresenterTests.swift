//
//  BTCPricePresenterTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import XCTest
import BTCKit

final class BTCPricePresenterTests: XCTestCase {
    
    func test_map_formatsPriceCorrectly() {
        let price = BTCPrice(price: Decimal(87769.24), timestamp: Date())
        
        let viewModel = BTCPricePresenter.map(price)
        
        XCTAssertEqual(viewModel.price, "$87,769.24")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.lastUpdatedDate)
    }
}
