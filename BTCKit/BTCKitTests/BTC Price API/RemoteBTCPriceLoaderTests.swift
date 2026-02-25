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
    
    func test_load_requestsDataFromURL() {
        let url = BTCPriceEndpoint.binance.url
        let (sut, client) = makeSUT(endpoint: .binance)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = BTCPriceEndpoint.binance.url
        let (sut, client) = makeSUT(endpoint: .binance)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT(endpoint: .binance)
        let error = anyNSError()
        
        expect(sut, toCompleteWith: .failure(error), when: {
            client.complete(with: error)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT(endpoint: .binance)
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(BTCPriceMapper.Error.invalidData), when: {
                let json = makeBinanceJSON(price: "87769.24")
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT(endpoint: .binance)
        let invalidJSON = Data("invalid json".utf8)
        
        expect(sut, toCompleteWith: .failure(BTCPriceMapper.Error.invalidData), when: {
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversPriceOn200HTTPResponseWithValidBinanceJSON() {
        let (sut, client) = makeSUT(endpoint: .binance)
        let price = "87769.24"
        let json = makeBinanceJSON(price: price)
        
        expect(sut, toCompleteWith: .success(BTCPrice(price: Decimal(string: price)!, timestamp: Date())), when: {
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversPriceOn200HTTPResponseWithValidCryptoCompareJSON() {
        let (sut, client) = makeSUT(endpoint: .cryptoCompare)
        let price = 87777.54
        let lastUpdate: TimeInterval = 1764035839
        let json = makeCryptoCompareJSON(price: price, lastUpdate: lastUpdate)
        
        expect(sut, toCompleteWith: .success(BTCPrice(price: Decimal(price), timestamp: Date(timeIntervalSince1970: lastUpdate))), when: {
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(endpoint: BTCPriceEndpoint, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteBTCPriceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteBTCPriceLoader(client: client, endpoint: endpoint)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteBTCPriceLoader, toCompleteWith expectedResult: BTCPriceLoader.Result,
                        when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expected), .success(received)):
                XCTAssertEqual(expected.price, received.price, "price", file: file, line: line)
            case let (.failure(expectedError as NSError), .failure(receivedError as NSError)):
                XCTAssertEqual(expectedError.domain, receivedError.domain, file: file, line: line)
                XCTAssertEqual(expectedError.code, receivedError.code, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeBinanceJSON(price: String) -> Data {
        let json: [String: Any] = [
            "symbol": "BTCUSDT",
            "price": price
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeCryptoCompareJSON(price: Double, lastUpdate: TimeInterval) -> Data {
        let json: [String: Any] = [
            "RAW": [
                "PRICE": price,
                "LASTUPDATE": lastUpdate
            ]
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
