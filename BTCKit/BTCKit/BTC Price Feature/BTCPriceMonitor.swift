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
    private let updateInterval: TimeInterval
    private let queue: DispatchQueue
    
    public init(
        primaryLoader: BTCPriceLoader,
        fallbackLoader: BTCPriceLoader,
        updateInterval: TimeInterval = 1.0,
        queue: DispatchQueue = .main
    ) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
        self.updateInterval = updateInterval
        self.queue = queue
    }
}
