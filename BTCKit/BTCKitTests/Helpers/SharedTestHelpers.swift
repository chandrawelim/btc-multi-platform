//
//  SharedTestHelpers.swift
//  BTCKitTests
//
//  Created by Welim, Chandra | ESDD on 2025/11/25.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int, url: URL = anyURL()) {
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

