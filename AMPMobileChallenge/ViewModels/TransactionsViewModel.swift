//
//  TransactionsViewModel.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import Foundation

class TransactionsViewModel {
    
    private let service: StarlingService
    let accountUid: String
    private let categoryUid: String
    var roundUpAmount: Double?
    
    var feedItems: [FeedItem] = []
    var isoDateString: String?
    
    init(
        accountUid: String,
        categoryUid: String,
        starlingService: StarlingService = StarlingService()
    ) {
        self.accountUid = accountUid
        self.categoryUid = categoryUid
        self.service = starlingService
    }
    
    func previousTransactionDayThreshold(days: Int) {
        if let pastDateThreshold = Date().subtract(days: days) {        
            isoDateString = Date().dateFormatter(date: pastDateThreshold)
        }
    }
    
    func getTransactionFeed() async {
        do {
            let transactionsData = try await service.fetchTransactions(
                for: accountUid,
                categoryId: categoryUid,
                since: isoDateString
            )
            feedItems = transactionsData.feedItems
            roundUpAmount = roundUpTransactionAmount(feedItems.compactMap { $0.amount })
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TransactionsViewModel {
    
    /// This function assume that rounding is taking place for both incoming and outgoing transactions
    /// - Parameter cents: The amount in cents (minor units).
    /// - Returns: The dollar value as a double
    
    private func roundUpTransactionAmount(_ amounts: [Amount]) -> Double {
        let minorUnits = amounts.map { $0.minorUnits }
        var dollarsArray: [Double] = []
        
        for unit in minorUnits {
            let dollarAmount = CurrencyFormatter.convertCentsToDollar(cents: unit)
            dollarsArray.append(dollarAmount)
        }
        let sum = dollarsArray.reduce(0, +)
        let roundedUpAmount = dollarsArray.map{ $0.rounded(.up)}.reduce(0, +)
        
        return roundedUpAmount - sum
    }
    
    // TODO: Create a function that just rounds to the next 100 instead of converting to dollar amounts
}
