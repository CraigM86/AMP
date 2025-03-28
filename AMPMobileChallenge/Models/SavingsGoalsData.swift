//
//  SavingsGoalsData.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 28/3/2025.
//

import Foundation

struct SavingsGoalsData: Decodable {
    let savingsGoalList: [SavingsGoal]
}

struct SavingsGoal: Decodable {
    let savingsGoalUid: String
    let name: String
    let target: Amount
    let totalSaved: Amount
    let savedPercentage: Double
}
