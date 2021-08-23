//
//  DateFormatter.swift
//  GECalendaDemo
//
//  Created by GoEun Jeong on 2021/08/23.
//
import Foundation

extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

extension Calendar {
    public func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}
