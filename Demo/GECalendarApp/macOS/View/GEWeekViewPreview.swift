//
//  GEWeekViewPreview.swift
//  GECalendarApp (iOS)
//
//  Created by GoEun Jeong on 2021/08/30.
//

import SwiftUI

struct GEWeekViewPreview: PreviewProvider {
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
            GEWeekView(selectedDate: $date, appearance: appearance)
            // Multiple Events - circle
            GEWeekView(selectedDate: $date, appearance: appearance4)
            // English
            GEWeekView(selectedDate: $date, appearance: appearance1)
            // today Color change
            GEWeekView(selectedDate: $nilDate, appearance: appearance2)
            // Events - text
            GEWeekView(selectedDate: $nilDate, appearance: appearance3)
        }
    }
}
