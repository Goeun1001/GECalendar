//
//  GECalendarPreview.swift
//  GECalendarDemo (iOS)
//
//  Created by GoEun Jeong on 2021/08/25.
//

import SwiftUI

struct Preview {
    static var mutipleEvents: [Event] = [Event(date: Calendar.current.date(byAdding: .weekday, value: -1, to: Date())!, title: "일정 1", color: Color.gray), Event(date: Calendar.current.date(byAdding: .weekday, value: -1, to: Date())!, title: "일정 2 ㅁㅁㅁㅁ", color: Color.gray), Event(date: Date(), title: "asdfasdf", color: Color.green), Event(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!, title: "asdfasdf", color: Color.gray)]
    static var events: [Date] = [Date(), Calendar.current.date(byAdding: .weekday, value: -1, to: Date())!, Calendar.current.date(byAdding: .weekday, value: +1, to: Date())!]
    static var headerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        return formatter
    }()
}

struct GECalendarPreviews: PreviewProvider {
    static let appearance = Appearance(selectionShape: .roundedRectangle(cornerRadius: 10), multipleEvents: Preview.mutipleEvents, isMultipleEvents: true, headerType: .leading)
    static let appearance1 = Appearance(events: Preview.events, eventType: .circle, headerType: .center, locale: Locale(identifier: "en-US"), headerDateFormatter: Preview.headerDateFormatter)
    static let appearance2 = Appearance(todayColor: Color.clear, defaultColor: Color.blue.opacity(0.2))
    static let appearance3 = Appearance(events: Preview.events, eventType: .text, eventColor: Color.red, headerType: .trailing)
    static let appearance4 = Appearance(eventType: .circle, selectionShape: .circle, multipleEvents: Preview.mutipleEvents, isMultipleEvents: true)
    
    @State static var date: Date? = Date()
    @State static var nilDate: Date? = nil
    
    static var previews: some View {
        Group {
            // Multiple Events - square
            GECalendar(selectedDate: $date, appearance: appearance)
            // Multiple Events - circle
            GECalendar(selectedDate: $date, appearance: appearance4)
            // English
            GECalendar(selectedDate: $date, appearance: appearance1)
            // today Color change
            GECalendar(selectedDate: $nilDate, appearance: appearance2)
            // Events - text
            GECalendar(selectedDate: $nilDate, appearance: appearance3)
        }
    }
}
