//
//  BTCPrice.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import Foundation

public struct BTCPrice: Equatable {
    public let price: Decimal
    public let timestamp: Date
    
    public init(price: Decimal, timestamp: Date) {
        self.price = price
        self.timestamp = timestamp
    }
}
