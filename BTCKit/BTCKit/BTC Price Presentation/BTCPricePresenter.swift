//
//  BTCPricePresenter.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import Foundation

public struct BTCPriceViewModel {
    public let price: String
    public let errorMessage: String?
    public let lastUpdatedDate: Date?
    
    public init(price: String, errorMessage: String? = nil, lastUpdatedDate: Date? = nil) {
        self.price = price
        self.errorMessage = errorMessage
        self.lastUpdatedDate = lastUpdatedDate
    }
}

public final class BTCPricePresenter {
    
    private static var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    public static func map(_ price: BTCPrice) -> BTCPriceViewModel {
        let formattedPrice = priceFormatter.string(from: price.price as NSDecimalNumber) ?? "$0.00"
        return BTCPriceViewModel(price: formattedPrice)
    }
    
    public static func mapError(lastUpdatedPrice: BTCPrice?) -> BTCPriceViewModel {
        let price: String
        let lastUpdatedDate: Date?
        
        if let lastUpdated = lastUpdatedPrice {
            price = priceFormatter.string(from: lastUpdated.price as NSDecimalNumber) ?? "$0.00"
            lastUpdatedDate = lastUpdated.timestamp
        } else {
            price = "$0.00"
            lastUpdatedDate = nil
        }
        
        let errorMessage: String
        if let date = lastUpdatedDate {
            let formattedDate = dateFormatter.string(from: date)
            errorMessage = "Failed to update value. Displaying last updated value from \(formattedDate)"
        } else {
            errorMessage = "Failed to load data"
        }
        
        return BTCPriceViewModel(
            price: price,
            errorMessage: errorMessage,
            lastUpdatedDate: lastUpdatedDate
        )
    }
}
