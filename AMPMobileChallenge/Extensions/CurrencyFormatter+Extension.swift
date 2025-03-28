//
//  CurrencyFormatter+Extension.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 28/3/2025.
//

import Foundation

struct CurrencyFormatter {
    static func formattedAmount(
        from amount: Amount,
        trasactionDirection: Direction
    ) -> String {
        let direction = trasactionDirection == .inbound ? "" : "-"
        let currencySymbol = amount.currency == "GBP" ? "£" : "$"
        let amountValue = convertCentsToDollar(cents: amount.minorUnits)
        let amountString = String(format: "%.2f", amountValue)
        return "\(direction)\(currencySymbol)\(amountString)"
    }
    
    static func convertCentsToDollar(cents: Int) -> Double {
        let dollarValue = Double(cents) / 100
        return round(dollarValue * 100) / 100
    }
    
    static func convertDollarToCents(dollar: Double) -> Int {
        let centsValue = Int(dollar * 100)
        return centsValue
    }
}
