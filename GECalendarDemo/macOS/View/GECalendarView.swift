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
                Button(action: {
                    self.selectedDate = date
                }, label: {
                    Text("00")
                        .hidden()
                        .padding(.vertical, geo.size.height / 15)
                        .padding(.horizontal, geo.size.width / 15)
                        
                        .background(
                            ZStack(alignment: .bottom) {
                                if appearance.eventType == .fill {
                                    appearance.eventColor?.first
                                } else if appearance.eventType == .circle && appearance.events.contains(where: {
                                    calendar.isDate(date, inSameDayAs: $0)
                                }) {
                                    Circle().frame(width: 6, height: 6)
                                        .foregroundColor(appearance.eventColor?.first)
                                }
                                
                                selectedDate != nil && calendar.isDate(date, inSameDayAs: selectedDate!) ? appearance.selectionColor
                                    : calendar.isDateInToday(date) ? appearance.todayColor
                                    : appearance.defaultColor
                                
                            }
                        )
                        .modifier(
                            ShapeModifier(shape: appearance.selectionShape)
                        )
                        .cornerRadius(4)
                        .overlay(
                            Group {
                                if appearance.eventType == .text && appearance.events.contains(date) {
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.eventColor?.first)
                                } else { // Event: None
                                    Text(String(self.calendar.component(.day, from: date)))
                                        .foregroundColor(appearance.dayColor)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                }).buttonStyle(PlainButtonStyle())
            }
            .environmentObject(appearance)
            .padding()
        }
    }
}

struct GECalendar_Previews: PreviewProvider {
    static let appearance = Appearance()
    
    static var previews: some View {
        Group {
            GECalendar(selectedDate: .constant(nil), appearance: appearance)
                .environment(\.locale, .init(identifier: "kr"))
                .frame(width: 900, height: 800)
        }
    }
}
