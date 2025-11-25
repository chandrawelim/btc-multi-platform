//
//  BTCPriceMapperTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import XCTest
import BTCKit

final class BTCPriceMapperTests: XCTestCase {
    
    // MARK: - Binance Tests
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeBinanceJSON(price: "87769.24")
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try BTCPriceMapper.map(json, from: HTTPURLResponse(statusCode: code),
                                       endpoint: .binance)
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try BTCPriceMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200),
                                   endpoint: .binance)
        )
    }
    
    func test_map_deliversPriceOn200HTTPResponseWithValidBinanceJSON() throws {
        let price = "87769.24"
        let json = makeBinanceJSON(price: price)
        
        let result = try BTCPriceMapper.map(json, from: HTTPURLResponse(statusCode: 200),
                                            endpoint: .binance)
        
        XCTAssertEqual(result.price, Decimal(string: price))
    }
    
    // MARK: - CryptoCompare Tests
    
    func test_map_throwsErrorOnNon200HTTPResponse_cryptoCompare() throws {
        let json = makeCryptoCompareJSON(price: 87777.54, lastUpdate: 1764035839)
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try BTCPriceMapper.map(json, from: HTTPURLResponse(statusCode: code),
                                       endpoint: .cryptoCompare)
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON_cryptoCompare() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try BTCPriceMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200),
                                   endpoint: .cryptoCompare)
        )
    }
    
    func test_map_deliversPriceOn200HTTPResponseWithValidCryptoCompareJSON() throws {
        let price = 87777.54
        let lastUpdate: TimeInterval = 1764035839
        let json = makeCryptoCompareJSON(price: price, lastUpdate: lastUpdate)
        
        let result = try BTCPriceMapper.map(json, from: HTTPURLResponse(statusCode: 200),
                                            endpoint: .cryptoCompare)
        
        XCTAssertEqual(result.price, Decimal(price))
        XCTAssertEqual(result.timestamp, Date(timeIntervalSince1970: lastUpdate))
    }
    
    // MARK: - Helpers
    
    private func makeBinanceJSON(price: String) -> Data {
        let json: [String: Any] = [
            "symbol": "BTCUSDT",
            "price": price
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeCryptoCompareJSON(price: Double, lastUpdate: TimeInterval) -> Data {
        let json: [String: Any] = [
            "RAW": [
                "MARKET": "CUSTOMAGG",
                "FROMSYMBOL": "BTC",
                "TOSYMBOL": "USD",
                "FLAGS": 0,
                "PRICE": price,
                "LASTUPDATE": lastUpdate,
                "LASTVOLUME": 0.00052148,
                "LASTVOLUMETO": 45.7742315592,
                "LASTTRADEID": "910886232",
                "VOLUME24HOUR": 14655.29000426,
                "VOLUME24HOURTO": 1281091563.37418,
                "OPEN24HOUR": 87031.24,
                "HIGH24HOUR": 89225.6,
                "LOW24HOUR": 85213.17,
                "LASTMARKET": "Coinbase",
                "TOPTIERVOLUME24HOUR": 14655.29000426,
                "TOPTIERVOLUME24HOURTO": 1281091563.37418,
                "CHANGE24HOUR": 746.299999999988,
                "CHANGEPCT24HOUR": 0.857508177523368,
                "CHANGEDAY": 0,
                "CHANGEPCTDAY": 0,
                "CHANGEHOUR": 0,
                "CHANGEPCTHOUR": 0
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

