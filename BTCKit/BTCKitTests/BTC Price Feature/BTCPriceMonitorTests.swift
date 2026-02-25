//
//  BTCPriceMonitorTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import XCTest
import BTCKit

final class BTCPriceMonitorTests: XCTestCase {
    
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
}
