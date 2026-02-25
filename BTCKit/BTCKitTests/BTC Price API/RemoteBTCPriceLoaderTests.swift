//
//  RemoteBTCPriceLoaderTests.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import XCTest
import BTCKit

final class RemoteBTCPriceLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT(endpoint: .binance)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(endpoint: BTCPriceEndpoint, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteBTCPriceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteBTCPriceLoader(client: client, endpoint: endpoint)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
}
