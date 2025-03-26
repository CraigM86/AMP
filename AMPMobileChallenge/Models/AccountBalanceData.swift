//
//  AccountBalanceData.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import Foundation

struct AccountBalanceData: Decodable {
    let amount: Amount
}

struct Amount: Decodable {
    let currency: String
    let minorUnits: Int
}
