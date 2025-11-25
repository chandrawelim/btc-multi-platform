//
//  BTCPriceEndpoint.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import Foundation

public enum BTCPriceEndpoint {
    case binance
    case cryptoCompare
    
    public var url: URL {
        switch self {
        case .binance:
            return URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")!
        case .cryptoCompare:
            return URL(string: "https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&e=coinbase")!
        }
    }
}


