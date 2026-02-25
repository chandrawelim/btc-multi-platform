//
//  BTCPriceMonitorTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import XCTest
import BTCKit

final class BTCPriceMonitorTests: XCTestCase {
    
    // MARK: - Helpers
    
    private func makeSUT(updateInterval: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) -> (sut: BTCPriceMonitor, primaryLoader: LoaderSpy, fallbackLoader: LoaderSpy, delegate: DelegateSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let delegate = DelegateSpy()
        let sut = BTCPriceMonitor(
            primaryLoader: primaryLoader,
            fallbackLoader: fallbackLoader,
            updateInterval: updateInterval,
            queue: .main
        )
        sut.delegate = delegate
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, primaryLoader, fallbackLoader, delegate)
    }
}

private class LoaderSpy: BTCPriceLoader {
    private var completions = [(BTCPriceLoader.Result) -> Void]()
    var loadCallCount: Int {
        return completions.count
    }
    
    func load(completion: @escaping (BTCPriceLoader.Result) -> Void) {
        completions.append(completion)
    }
    
    func complete(with result: BTCPriceLoader.Result, at index: Int = 0) {
        completions[index](result)
    }
}

private class DelegateSpy: BTCPriceMonitorDelegate {
    var receivedViewModels = [BTCPriceViewModel]()
    
    func didUpdatePrice(_ viewModel: BTCPriceViewModel) {
        receivedViewModels.append(viewModel)
    }
}
