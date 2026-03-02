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
    private var timer: Timer?
    private var isUpdating = false
    private var lastSuccessfulPrice: BTCPrice?
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
    
    public func start() {
        stop()
        updatePrice()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.updatePrice()
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updatePrice() {
        guard !isUpdating else { return }
        isUpdating = true
        
        primaryLoader.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let price):
                lastSuccessfulPrice = price
                queue.async { [weak self] in
                    self?.delegate?.didUpdatePrice(BTCPricePresenter.map(price))
                }
                isUpdating = false
            case .failure:
                fallbackLoader.load { [weak self] fallbackResult in
                    guard let self = self else { return }
                    switch fallbackResult {
                    case .success(let price):
                        lastSuccessfulPrice = price
                        queue.async { [weak self] in
                            self?.delegate?.didUpdatePrice(BTCPricePresenter.map(price))
                        }
                    case .failure:
                        break
                    }
                    isUpdating = false
                }
            }
        }
    }
}
