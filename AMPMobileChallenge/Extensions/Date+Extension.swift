//
//  Date+Extension.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 27/3/2025.
//

import Foundation

extension Date {
    func subtract(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = -days
        return Calendar.current.date(byAdding: dateComponents, to: self)
    }
    
    func dateFormatter(date: Date) -> String {
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.string(from: date)
    }
}
