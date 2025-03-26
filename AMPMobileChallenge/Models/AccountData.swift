//
//  AccountData.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import Foundation


struct AccountData: Decodable {
    let accounts: [Account]
}

struct Account: Decodable {
    let accountUid: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String
}
