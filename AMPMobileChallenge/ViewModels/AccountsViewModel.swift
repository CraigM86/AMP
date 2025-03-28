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
    var accountBalances: [String: Amount] = [:]
    
    init(starlingService: StarlingService = StarlingService()) {
        self.service = starlingService
    }
    
    func getAccounts() async {
        do {
            let accountData = try await service.fetchAccounts()
            await MainActor.run {
                accounts = accountData.accounts
            }
        } catch {
            print("Failed to fetch accounts: \(error.localizedDescription)")
        }
    }
    
    func getAccountBalanceByID(_ accountID: String) async {
        do {
            let accountBalanceData = try await service.fetchAccountBalance(for: accountID)
            accountBalances[accountID] = accountBalanceData.amount
        } catch {
            print("Failed to fetch account Balance: \(error.localizedDescription)")
        }
    }

    func balance(for accountID: String) -> Amount? {
        return accountBalances[accountID]
    }
}
