//
//  TransactionData.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import Foundation

enum Direction: String, Decodable {
    case inbound = "IN"
    case outbound = "OUT"
}

struct TransactionData: Decodable {
    let feedItems: [FeedItem]
}

struct FeedItem: Decodable {
    let feedItemUid: String
    let categoryUid: String
    let amount: Amount
    let direction: Direction
    let counterPartyName: String
}
