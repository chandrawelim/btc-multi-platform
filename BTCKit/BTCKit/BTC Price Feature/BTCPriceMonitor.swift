//
//  BTCPriceMonitor.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import Foundation

public protocol BTCPriceMonitorDelegate: AnyObject {
    func didUpdatePrice(_ viewModel: BTCPriceViewModel)
}

public final class BTCPriceMonitor {
    public weak var delegate: BTCPriceMonitorDelegate?
    
    private let primaryLoader: BTCPriceLoader
    private let fallbackLoader: BTCPriceLoader
    
    public init(
        primaryLoader: BTCPriceLoader,
        fallbackLoader: BTCPriceLoader
    ) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
}
