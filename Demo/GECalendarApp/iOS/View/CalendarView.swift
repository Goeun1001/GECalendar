//
//  WeekView.swift
//  GECalendaDemo (iOS)
//
//  Created by GoEun Jeong on 2021/08/23.
//
// https://swiftwithmajid.com/2020/05/06/building-calendar-without-uicollectionview-in-swiftui/
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Environment(\.calendar) var calendar
    
    @Published var months = [Date]()
    
    init() {
        self.months = calendar.generateDates(
            inside: calendar.dateInterval(of: .quarter, for: Date())!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    func changeDateBy(_ newIndex: Int) {
//        print("from: \(self.months)")
        if newIndex == 0 {
            // left
            if let date = Calendar.current.date(byAdding: .month, value: -1, to: months[0]) {
                
                self.months[2] = self.months[1]
                self.months[1] = self.months[0]
                self.months[0] = date
            }
        } else {
            // right
            if let date = Calendar.current.date(byAdding: .month, value: 1, to: months[2]) {
                self.months[0] = self.months[1]
                self.months[1] = self.months[2]
                self.months[2] = date
            }
        }
//        print("to: \(self.months)")
    }
    
    func today() {
        self.months = calendar.generateDates(
            inside: calendar.dateInterval(of: .quarter, for: Date())!,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
}


struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var appearance: Appearance
    @ObservedObject var calendarVM = CalendarViewModel()
    @State private var currentPage = 1
    
    private let interval: DateInterval
    private let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    func updateMonthsAfterPagerSwipe(newIndex:Int) {
        self.calendarVM.changeDateBy(newIndex)
        self.currentPage = 1
    }
    
    var body: some View {
        PagerView(pageCount: self.calendarVM.months.count, currentIndex: self.$currentPage, pageChanged: self.updateMonthsAfterPagerSwipe) {
            ForEach(calendarVM.months, id: \.self) { month in
                MonthView(month: month, content: self.content)
                    .environmentObject(calendarVM)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static let appearance = Appearance()
    @State static var date: Date? = Date()
    
    static var previews: some View {
        Group {
            GECalendar(selectedDate: $date, appearance: appearance)
        }
    }
}

