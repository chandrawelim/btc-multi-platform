//
//  BTCPriceMapper.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import Foundation

public final class BTCPriceMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse,
                           endpoint: BTCPriceEndpoint) throws -> BTCPrice {
        guard response.isOK else {
            throw Error.invalidData
        }
        
        switch endpoint {
        case .binance:
            return try mapBinanceResponse(data)
        case .cryptoCompare:
            return try mapCryptoCompareResponse(data)
        }
    }
    
    private static func mapBinanceResponse(_ data: Data) throws -> BTCPrice {
        struct BinanceResponse: Decodable {
            let symbol: String
            let price: String
        }
        
        guard let response = try? JSONDecoder().decode(BinanceResponse.self, from: data),
              let price = Decimal(string: response.price) else {
            throw Error.invalidData
        }
        
        return BTCPrice(price: price, timestamp: Date())
    }
    
    private static func mapCryptoCompareResponse(_ data: Data) throws -> BTCPrice {
        struct CryptoCompareResponse: Decodable {
            let RAW: RawData
            
            struct RawData: Decodable {
                let PRICE: Double
                let LASTUPDATE: TimeInterval
            }
        }
        
        guard let response = try? JSONDecoder().decode(CryptoCompareResponse.self, from: data) else {
            throw Error.invalidData
        }
        
        let price = Decimal(response.RAW.PRICE)
        let timestamp = Date(timeIntervalSince1970: response.RAW.LASTUPDATE)
        
        return BTCPrice(price: price, timestamp: timestamp)
    }
}

private extension HTTPURLResponse {
    var isOK: Bool {
        return statusCode == 200
    }
}
