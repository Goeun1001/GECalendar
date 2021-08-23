//
//  GECalendarView.swift
//  GECalendaDemo
//
//  Created by GoEun Jeong on 2021/08/23.
//

import SwiftUI

public struct GECalendar: View {
    @Environment(\.calendar) var calendar
    private var quarter: DateInterval {
        calendar.dateInterval(of: .quarter, for: Date())!
    }
    @State private var selectedDate = Date()
    @ObservedObject var appearance: Appearance
    
    init(appearance: Appearance) {
        self.appearance = appearance
    }
    
    public var body: some View {
        VStack{
            CalendarView(interval: self.quarter) { date in
                Text("00")
                    .hidden()
                    .padding(8)
                    .background(
                        Group {
                            switch appearance.eventType {
                            case .fill:
                                calendar.isDate(date, inSameDayAs: selectedDate) ? appearance.selectionColor
                                    : calendar.isDateInToday(date) ? appearance.todayColor
                                    : appearance.defaultColor
                            default:
                                Text("")
                                    .hidden()
                            }
                        }
                    )
                    .clipShape(
                        Rectangle()
                    )
                    .cornerRadius(4)
                    .padding(4)
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date)))
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                self.selectedDate = date
                            }
                    )
            }
            .environmentObject(appearance)
            Spacer()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static let appearance = Appearance()
    
    static var previews: some View {
        Group {
            GECalendar(appearance: appearance)
                .environment(\.locale, .init(identifier: "kr"))
        }
    }
}
