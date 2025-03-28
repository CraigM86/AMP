//
//  SavingsGoalViewModel.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 28/3/2025.
//

import Foundation

class SavingsGoalViewModel {
    private let service: StarlingService
    
    var accounts: [Account] = []
    var savingsGoals: [SavingsGoal] = []
    
    init(service: StarlingService = StarlingService()) {
        self.service = service
    }
    
    func getAccounts() async {
        do {
            let accountData = try await service.fetchAccounts()
            accounts = accountData.accounts
        } catch {
            print("Failed to fetch accounts: \(error.localizedDescription)")
        }
    }
    
    func fetchSavingGoalsForID(_ accountID: String) async {
        do {
            let goals = try await service.fetchSavingsGoal(for: accountID)
            savingsGoals.append(contentsOf: goals.savingsGoalList)
        } catch {
            print("Failed to fetch Savings Goals: \(error.localizedDescription)")
        }
    }
}
