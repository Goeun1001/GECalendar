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
        calendar.dateInterval(of: .quarter, for:  Calendar.current.date(byAdding: .month, value: 1, to: Date())!)!
    }
    @Binding private var selectedDate: Date?
    @ObservedObject var appearance: Appearance
    
    public init(selectedDate: Binding<Date?>,
                appearance: Appearance) {
        self._selectedDate = selectedDate
        self.appearance = appearance
    }
    
    public var body: some View {
        GeometryReader { geo in
            CalendarView(interval: self.quarter) { date in
                Text("00")
                    .hidden()
                    .padding(8)
                    .background(
                        ZStack(alignment: .bottom) {
                            if calendar.isDateInToday(date) {
                                appearance.todayColor
                                    .modifier(
                                        ShapeModifier(shape: appearance.selectionShape)
                                    )
                            }
                            
                            // mutiple events
                            if appearance.isMultipleEvents {
                                if appearance.eventType == .fill && appearance.multipleEvents.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0.date)
                                }) {
                                    appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }.first!.color
                                } else if appearance.eventType == .circle && appearance.multipleEvents.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0.date)
                                }) {
                                    HStack(spacing: 3) {
                                        ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                            event in
                                            Circle().frame(width: 7, height: 7)
                                                .foregroundColor(event.color)
                                                .padding(.top, 10)
                                        }
                                    }
                                } else if appearance.eventType == .line && appearance.multipleEvents.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0.date)
                                }) {
                                    VStack(spacing: 1) {
                                        ForEach(appearance.multipleEvents.filter { calendar.isDate(date, inSameDayAs: $0.date) }, id: \.self) {
                                            event in
                                            RectangleView(color: event.color)
                                        }
                                    }
                                }
                                
                            } else {
                                // single events
                                if appearance.eventType == .fill && appearance.events.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    appearance.eventColor
                                } else if appearance.eventType == .circle && appearance.events.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    Circle().frame(width: 7, height: 7)
                                        .foregroundColor(appearance.eventColor)
                                } else if appearance.eventType == .line && appearance.events.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    HStack {
                                        Rectangle()
                                            .frame(height: 5)
                                    }
                                }
                            }
                            
                            // common dates
                            if selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!) {
                                appearance.selectionColor
                                    .modifier(
                                        ShapeModifier(shape: appearance.selectionShape)
                                    )
                            }  else {
                                appearance.defaultColor
                                    .modifier(
                                        ShapeModifier(shape: appearance.defaultShape)
                                    )
                            }
                        }
                    )
                    .cornerRadius(4)
                    .padding(4)
                    .overlay(
                        Group {
                            if appearance.eventType == .text && appearance.events.contains(where: {
                                calendar.isDate(date, inSameDayAs: $0)
                            }) {
                                Text(String(self.calendar.component(.day, from: date)))
                                    .foregroundColor(appearance.eventColor)
                                    .onTapGesture {
                                        self.selectedDate = date
                                    }
                            } else { // Event: None
                                Text(String(self.calendar.component(.day, from: date)))
                                    .foregroundColor(appearance.dayColor)
                                    .onTapGesture {
                                        self.selectedDate = date
                                    }
                            }
                        }
                    )
            }.frame(height: UIScreen.main.bounds.height / 2)
            .environmentObject(appearance)
        }
    }
}

struct RectangleView: View {
    let color: Color
    let rounded = false
    let cornerRadius: CGFloat = 10.0
    
    var body: some View {
        if rounded {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(color)
                .frame(height: 5)
        } else {
            Rectangle()
                .foregroundColor(color)
                .frame(height: 5)
        }
    }
}

struct GECalendar_Previews: PreviewProvider {
    static let appearance = Appearance()
    @State static var date: Date? = Date()
    
    static var previews: some View {
        Group {
            GECalendar(selectedDate: $date, appearance: appearance)
        }
    }
}
