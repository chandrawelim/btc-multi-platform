//
//  BTCPriceMonitorTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import XCTest
import BTCKit

final class BTCPriceMonitorTests: XCTestCase {
    
    func test_init_doesNotStartMonitoring() {
        let (_, primaryLoader, fallbackLoader, delegate) = makeSUT()
        
        XCTAssertEqual(primaryLoader.loadCallCount, 0)
        XCTAssertEqual(fallbackLoader.loadCallCount, 0)
        XCTAssertEqual(delegate.receivedViewModels.count, 0)
    }
    
    func test_start_requestsPriceFromPrimaryLoader() {
        let (sut, primaryLoader, _, _) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(primaryLoader.loadCallCount, 1)
    }
    
    func test_start_schedulesUpdatesAtInterval() {
        let (sut, primaryLoader, _, _) = makeSUT(updateInterval: 0.1)
        
        sut.start()
   
        DispatchQueue.main.async {
            primaryLoader.complete(with: .success(BTCPrice(price: Decimal(0), timestamp: Date())))
        }
        
        let exp = expectation(description: "Wait for timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertGreaterThan(primaryLoader.loadCallCount, 1)
    }
    
    func test_start_onPrimarySuccess_notifiesDelegateWithMappedViewModel() {
        let (sut, primaryLoader, _, delegate) = makeSUT()
        let price = BTCPrice(price: Decimal(87769.24), timestamp: Date())
        
        sut.start()
        primaryLoader.complete(with: .success(price))
        
        expectDelegateToReceiveViewModel(on: .main, timeout: 1.0)
        
        XCTAssertEqual(delegate.receivedViewModels.count, 1)
        XCTAssertEqual(delegate.receivedViewModels.first?.price, "$87,769.24")
        XCTAssertNil(delegate.receivedViewModels.first?.errorMessage)
        XCTAssertNil(delegate.receivedViewModels.first?.lastUpdatedDate)
    }
    
    func test_start_onPrimaryFailure_requestsFallbackLoader() {
        let (sut, primaryLoader, fallbackLoader, _) = makeSUT()
        
        sut.start()
        primaryLoader.complete(with: .failure(anyNSError()))
        
        XCTAssertEqual(primaryLoader.loadCallCount, 1)
        XCTAssertEqual(fallbackLoader.loadCallCount, 1)
    }
    
    func test_start_onPrimaryFailureAndFallbackSuccess_notifiesDelegateWithMappedViewModel() {
        let (sut, primaryLoader, fallbackLoader, delegate) = makeSUT()
        let price = BTCPrice(price: Decimal(50000), timestamp: Date())
        
        sut.start()
        primaryLoader.complete(with: .failure(anyNSError()))
        fallbackLoader.complete(with: .success(price))
        
        expectDelegateToReceiveViewModel(on: .main, timeout: 1.0)
        
        XCTAssertEqual(delegate.receivedViewModels.count, 1)
        XCTAssertEqual(delegate.receivedViewModels.first?.price, "$50,000.00")
        XCTAssertNil(delegate.receivedViewModels.first?.errorMessage)
    }
    
    // MARK: - Helpers
    
    private func expectDelegateToReceiveViewModel(on queue: DispatchQueue, timeout: TimeInterval = 1.0) {
        let exp = expectation(description: "Wait for delegate callback")
        queue.async { exp.fulfill() }
        wait(for: [exp], timeout: timeout)
    }
    
    private func makeSUT(updateInterval: TimeInterval = 1.0, queue: DispatchQueue = .main, file: StaticString = #file, line: UInt = #line) -> (sut: BTCPriceMonitor, primaryLoader: LoaderSpy, fallbackLoader: LoaderSpy, delegate: DelegateSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let delegate = DelegateSpy()
        let sut = BTCPriceMonitor(
            primaryLoader: primaryLoader,
            fallbackLoader: fallbackLoader,
            updateInterval: updateInterval,
            queue: queue
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
