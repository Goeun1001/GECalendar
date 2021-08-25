//
//  File.swift
//  
//
//  Created by GoEun Jeong on 2021/08/25.
//

#if os(iOS)

import SwiftUI

@available(iOS 14, *)
struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var appearance: Appearance
    
    let week: Date
    let content: (Date) -> DateView
    
    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date)
                            .opacity(appearance.extraDayOpacity)
                    }
                }
            }
        }
    }
}

#endif
