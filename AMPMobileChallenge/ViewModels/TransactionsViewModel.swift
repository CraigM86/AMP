//
//  TransactionsViewModel.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import Foundation

class TransactionsViewModel {
    
    private let service: StarlingService
    private let accountUid: String
    private let categoryUid: String
    
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
        } catch {
            print(error.localizedDescription)
        }
    }
}
