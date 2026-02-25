//
//  BTCPriceLoader.swift
//  BTCKit
//
//  Created by Welim, Chandra | ESDD on 2026/02/25.
//

import Foundation

public protocol BTCPriceLoader {
    typealias Result = Swift.Result<BTCPrice, Error>
    
    func load(completion: @escaping (Result) -> Void)
}
