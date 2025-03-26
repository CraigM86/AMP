//
//  AccountsViewModel.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import Foundation

class AccountsViewModel {
    private let service: StarlingService
    
    var accounts: [Account] = []
    var amount: Amount?
    
    init(starlingService: StarlingService = StarlingService()) {
        self.service = starlingService
    }
    
    func getAccounts() async {
        do {
            let accountData = try await service.fetchAccounts()
            accounts = accountData.accounts
        } catch {
            print("Failed to fetch accounts: \(error.localizedDescription)")
        }
    }
    
    func getAccountBalanceByID(_ accountID: String) async {
        do {
            let balance = try await service.fetchAccountBalance(for: accountID)
            amount = balance.amount
        } catch {
            print("Failed to fetch account Balance: \(error.localizedDescription)")
        }
    }
}
