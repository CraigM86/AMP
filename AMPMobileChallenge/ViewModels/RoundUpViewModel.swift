//
//  RoundUpViewModel.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import Foundation

class RoundUpViewModel {
    private let service: StarlingService
    let accountUid: String
    let roundUpAmount: Double?
    
    var savingsGoals: [SavingsGoal] = []
    
    init(
        accountUid: String,
        roundUpAmount: Double,
        service: StarlingService = StarlingService()
    ) {
        self.accountUid = accountUid
        self.roundUpAmount = roundUpAmount
        self.service = service
    }
    
    func fetchSavingGoalsForID(_ accountID: String) async {
        do {
            let goals = try await service.fetchSavingsGoal(for: accountID)
            savingsGoals = goals.savingsGoalList
        } catch {
            print("Failed to fetch Savings Goals: \(error.localizedDescription)")
        }
    }
    
    func addMoneyToSavingsGoal(savingsGoalID: String) async {
        do {
            try await service.addRoundupToSavingsGoal(
                accountID: accountUid,
                savingsGoalUid: savingsGoalID,
                transferUid: UUID().uuidString,
                minorUnits: CurrencyFormatter.convertDollarToCents(dollar: roundUpAmount ?? 0.0)
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
