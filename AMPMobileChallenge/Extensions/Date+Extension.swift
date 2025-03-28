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
    
    // This is not how I would handle this in a real project
    func formatDateToAEDT(from isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        let localFormatter = DateFormatter()
        localFormatter.dateFormat = "E d MMM"
        localFormatter.timeZone = TimeZone(identifier: "Australia/Sydney")
        
        return localFormatter.string(from: date)
    }
}
