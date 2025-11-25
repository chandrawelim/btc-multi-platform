//
//  BTCPriceEndpointTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import XCTest
import BTCKit

final class BTCPriceEndpointTests: XCTestCase {
    
    func test_binance_endpointURL() {
        let url = BTCPriceEndpoint.binance.url
        
        XCTAssertEqual(url.absoluteString, "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")
    }
    
    func test_cryptoCompare_endpointURL() {
        let url = BTCPriceEndpoint.cryptoCompare.url
        
        XCTAssertEqual(url.absoluteString, "https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&e=coinbase")
    }
}
