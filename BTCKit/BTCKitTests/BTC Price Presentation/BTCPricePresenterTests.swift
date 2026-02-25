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
    
    func test_mapError_withLastUpdatedPrice_displaysErrorMessageWithDate() {
        let date = Date(timeIntervalSince1970: 1764035839)
        let lastUpdatedPrice = BTCPrice(price: Decimal(87769.24), timestamp: date)
        
        let viewModel = BTCPricePresenter.mapError(lastUpdatedPrice: lastUpdatedPrice)
        
        XCTAssertEqual(viewModel.price, "$87,769.24")
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage!.contains("Failed to update value"))
        XCTAssertTrue(viewModel.errorMessage!.contains("Displaying last updated value"))
        XCTAssertEqual(viewModel.lastUpdatedDate, date)
    }
    
    func test_mapError_withoutLastUpdatedPrice_displaysGenericErrorMessage() {
        let viewModel = BTCPricePresenter.mapError(lastUpdatedPrice: nil)
        
        XCTAssertEqual(viewModel.price, "$0.00")
        XCTAssertEqual(viewModel.errorMessage, "Failed to load data")
        XCTAssertNil(viewModel.lastUpdatedDate)
    }
}
