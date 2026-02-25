//
//  RemoteBTCPriceLoader.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import Foundation

public final class RemoteBTCPriceLoader: BTCPriceLoader {
    private let client: HTTPClient
    private let endpoint: BTCPriceEndpoint
    
    public init(client: HTTPClient, endpoint: BTCPriceEndpoint) {
        self.client = client
        self.endpoint = endpoint
    }
    
    public func load(completion: @escaping (BTCPriceLoader.Result) -> Void) {
        client.get(from: endpoint.url) { result in
            switch result {
            case let .success((data, response)):
                completion(Result {
                    try BTCPriceMapper.map(data, from: response, endpoint: self.endpoint)
                })
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
